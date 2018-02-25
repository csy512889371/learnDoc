# DTO 与VO的转换

项目中处理bean与DTO VO 的转换 
* jpa 本地查询，返回结果直接是DTO 。参照 <spring data jpa 使用技巧>
* bean 与DTO 字段差异比较大时。定义convertPagePOtoVO
* bean与DTO 字段 包含关系：BeanUtils 工具转换


# 方式一、DTO 与VO 属性差别大时定义: convertPagePOtoVO

## 1、List 转换
* 定义vo类 DemoVO 继承 BaseVO
* 将ArrayList 转为 ListVO

```java
ListVO<DemoVO> listVO = new ListVO<>(demoList, DemoVO.class);
```

## 2、Page 转换
* 对分页查询转换
* pageInfo 为 import org.springframework.data.domain.Page;
* PageVO 中包含了分页的相关信息

```java
PageVO<DemoVO> pageVO = new PageVO<>(pageInfo, DemoVO.class);
```

## 3、对象转换

```java

DemoVO demoVO = new DemoVO();
demoVO.convertPOToVO(demoEntity);

```

## 4、相关代码
> BaseVO
```java
public interface BaseVO {
	void convertPOToVO(Object poObj);
}

```

> ListVO
```java
@Data
@Slf4j
public class ListVO<T extends BaseVO> {

	private List<T> voList = new ArrayList<T>();
	
	public ListVO(List poList, Class<T> VOType){
		for(Object obj : poList){
			try {
				BaseVO vo = VOType.newInstance();
				vo.convertPOToVO(obj);
				voList.add((T) vo);
			} catch (InstantiationException e) {
				log.error(e.getMessage(), e);
			} catch (IllegalAccessException e) {
				log.error(e.getMessage(), e);
			}
		}
	}
	
	public ListVO(Set poList, Class<T> VOType){
		for(Object obj : poList){
			try {
				BaseVO vo = VOType.newInstance();
				vo.convertPOToVO(obj);
				voList.add((T) vo);
			} catch (InstantiationException e) {
				log.error(e.getMessage(), e);
			} catch (IllegalAccessException e) {
				log.error(e.getMessage(), e);
			}
		}
	}

}
```
> PageVO

```java
@Data
@Slf4j
public class PageVO<T extends BaseVO> {

    List<T> pageData = new ArrayList<T>();

    private int currentPage;

    private int totalPage;

    private int pageSize;

    private long totalRows;

    public PageVO(int pageSize, int currentPage, long totalRows, int totalPage) {
        this.pageSize = pageSize;
        this.currentPage = currentPage;
        this.totalRows = totalRows;
        this.totalPage = totalPage;
//		totalPage = totalRows%pageSize==0?totalRows/pageSize:totalRows/pageSize+1;
    }

    /**
     * 转换数据库取出来的List到页面展示需要的page
     *
     * @param poList
     * @param VOType
     */
    public PageVO(List poList, Class<T> VOType) {
        if (poList != null) {
            this.totalPage = 1;
            this.totalRows = poList.size();
            this.currentPage = 1;
            this.pageSize = poList.size();
            this.convertPagePOtoVO(poList, VOType);
        }

    }

    /**
     * 转换数据库取出来的page到页面展示需要的page,
     *
     * @param page
     * @param VOType //目标VO的class 对象
     */
    public PageVO(Page page, Class<T> VOType) {
        this(page.getSize(), page.getNumber(), page.getTotalElements(), page.getTotalPages());

        this.convertPagePOtoVO(page.getContent(), VOType);
    }


    private void convertPagePOtoVO(List poList, Class<T> VOType) {
        try {
            for (Object poObj : poList) {
                BaseVO voObj = (BaseVO) VOType.newInstance();
                voObj.convertPOToVO(poObj);
                pageData.add((T) voObj);
            }
        } catch (InstantiationException e) {
            log.error(e.getMessage(), e);
        } catch (IllegalAccessException e) {
            log.error(e.getMessage(), e);
        }
    }

}
```

# 方式二、BeanUtils

## 1、对List的转换
```java
    List<App> app = null;
    BeanUtils.batchTransform(AppDTO.class, app);
```

## 2、对象转换

```java
    App app = appService.findOne(appId);
    BeanUtils.transfrom(AppDTO.class, app);
```

## 3、page转换

```java
    private PageDTO<DemoVO> transform2PageDTO(Page<DemoEntity> pageInfo, Pageable pageable){
        if (!pageInfo.hasContent()) {
            return null;
        }
        List<DemoVO> demoVOList = BeanUtils.batchTransform(DemoVO.class, pageInfo.getContent());
        return new PageDTO<DemoVO>(demoVOList, pageable, pageInfo.getTotalElements());
    }
```


> BeanUtils

```java
public class BeanUtils {

  /**
   * <pre>
   *     List<UserBean> userBeans = userDao.queryUsers();
   *     List<UserDTO> userDTOs = BeanUtil.batchTransform(UserDTO.class, userBeans);
   * </pre>
   */
  public static <T> List<T> batchTransform(final Class<T> clazz, List<? extends Object> srcList) {
    if (CollectionUtils.isEmpty(srcList)) {
      return Collections.emptyList();
    }

    List<T> result = new ArrayList<>(srcList.size());
    for (Object srcObject : srcList) {
      result.add(transfrom(clazz, srcObject));
    }
    return result;
  }

  /**
   * 封装{@link org.springframework.beans.BeanUtils#copyProperties}，惯用与直接将转换结果返回
   *
   * <pre>
   *      UserBean userBean = new UserBean("username");
   *      return BeanUtil.transform(UserDTO.class, userBean);
   * </pre>
   */
  public static <T> T transfrom(Class<T> clazz, Object src) {
    if (src == null) {
      return null;
    }
    T instance = null;
    try {
      instance = clazz.newInstance();
    } catch (Exception e) {
      throw new BeanUtilsException(e);
    }
    org.springframework.beans.BeanUtils.copyProperties(src, instance, getNullPropertyNames(src));
    return instance;
  }

  private static String[] getNullPropertyNames(Object source) {
    final BeanWrapper src = new BeanWrapperImpl(source);
    PropertyDescriptor[] pds = src.getPropertyDescriptors();

    Set<String> emptyNames = new HashSet<String>();
    for (PropertyDescriptor pd : pds) {
      Object srcValue = src.getPropertyValue(pd.getName());
      if (srcValue == null) emptyNames.add(pd.getName());
    }
    String[] result = new String[emptyNames.size()];
    return emptyNames.toArray(result);
  }

  /**
   * 用于将一个列表转换为列表中的对象的某个属性映射到列表中的对象
   *
   * <pre>
   *      List<UserDTO> userList = userService.queryUsers();
   *      Map<Integer, userDTO> userIdToUser = BeanUtil.mapByKey("userId", userList);
   * </pre>
   *
   * @param key 属性名
   */
  @SuppressWarnings("unchecked")
  public static <K, V> Map<K, V> mapByKey(String key, List<? extends Object> list) {
    Map<K, V> map = new HashMap<K, V>();
    if (CollectionUtils.isEmpty(list)) {
      return map;
    }
    try {
      Class<? extends Object> clazz = list.get(0).getClass();
      Field field = deepFindField(clazz, key);
      if (field == null) throw new IllegalArgumentException("Could not find the key");
      field.setAccessible(true);
      for (Object o : list) {
        map.put((K) field.get(o), (V) o);
      }
    } catch (Exception e) {
      throw new BeanUtilsException(e);
    }
    return map;
  }

  /**
   * 根据列表里面的属性聚合
   *
   * <pre>
   *       List<ShopDTO> shopList = shopService.queryShops();
   *       Map<Integer, List<ShopDTO>> city2Shops = BeanUtil.aggByKeyToList("cityId", shopList);
   * </pre>
   */
  @SuppressWarnings("unchecked")
  public static <K, V> Map<K, List<V>> aggByKeyToList(String key, List<? extends Object> list) {
    Map<K, List<V>> map = new HashMap<K, List<V>>();
    if (CollectionUtils.isEmpty(list)) {// 防止外面传入空list
      return map;
    }
    try {
      Class<? extends Object> clazz = list.get(0).getClass();
      Field field = deepFindField(clazz, key);
      if (field == null) throw new IllegalArgumentException("Could not find the key");
      field.setAccessible(true);
      for (Object o : list) {
        K k = (K) field.get(o);
        if (map.get(k) == null) {
          map.put(k, new ArrayList<V>());
        }
        map.get(k).add((V) o);
      }
    } catch (Exception e) {
      throw new BeanUtilsException(e);
    }
    return map;
  }

  /**
   * 用于将一个对象的列表转换为列表中对象的属性集合
   *
   * <pre>
   *     List<UserDTO> userList = userService.queryUsers();
   *     Set<Integer> userIds = BeanUtil.toPropertySet("userId", userList);
   * </pre>
   */
  @SuppressWarnings("unchecked")
  public static <K> Set<K> toPropertySet(String key, List<? extends Object> list) {
    Set<K> set = new HashSet<K>();
    if (CollectionUtils.isEmpty(list)) {// 防止外面传入空list
      return set;
    }
    try {
      Class<? extends Object> clazz = list.get(0).getClass();
      Field field = deepFindField(clazz, key);
      if (field == null) throw new IllegalArgumentException("Could not find the key");
      field.setAccessible(true);
      for (Object o : list) {
        set.add((K)field.get(o));
      }
    } catch (Exception e) {
      throw new BeanUtilsException(e);
    }
    return set;
  }


  private static Field deepFindField(Class<? extends Object> clazz, String key) {
    Field field = null;
    while (!clazz.getName().equals(Object.class.getName())) {
      try {
        field = clazz.getDeclaredField(key);
        if (field != null) {
          break;
        }
      } catch (Exception e) {
        clazz = clazz.getSuperclass();
      }
    }
    return field;
  }

  /**
   * 获取某个对象的某个属性
   */
  public static Object getProperty(Object obj, String fieldName) {
    try {
      Field field = deepFindField(obj.getClass(), fieldName);
      if (field != null) {
        field.setAccessible(true);
        return field.get(obj);
      }
    } catch (Exception e) {
      throw new BeanUtilsException(e);
    }
    return null;
  }

  /**
   * 设置某个对象的某个属性
   */
  public static void setProperty(Object obj, String fieldName, Object value) {
    try {
      Field field = deepFindField(obj.getClass(), fieldName);
      if (field != null) {
        field.setAccessible(true);
        field.set(obj, value);
      }
    } catch (Exception e) {
      throw new BeanUtilsException(e);
    }
  }

  /**
   * 
   * @param source
   * @param target
   */
  public static void copyProperties(Object source, Object target, String... ignoreProperties) {
    org.springframework.beans.BeanUtils.copyProperties(source, target, ignoreProperties);
  }

  /**
   * The copy will ignore <em>BaseEntity</em> field
   *
   * @param source
   * @param target
   */
  public static void copyEntityProperties(Object source, Object target) {
    org.springframework.beans.BeanUtils.copyProperties(source, target, COPY_IGNORED_PROPERTIES);
  }
  
  private static final String[] COPY_IGNORED_PROPERTIES = {"id", "dataChangeCreatedBy", "dataChangeCreatedTime", "dataChangeLastModifiedTime"};
}
```


