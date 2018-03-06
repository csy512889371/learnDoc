# jpa 对象关联

* one-to-one-primarykey 一对一 主键
* one-to-one-foreignkey 一对一 外键
* one-to-many 一对多
* many-to-many-extra-columns 多对多中间表有额外字段
* many-to-many 多对多


* 代码 地址 https://github.com/csy512889371/learndemo/tree/master/ctoedu-jap-example


## 一、one-to-one-primarykey 一对一 主键

```java
@Entity
@Data
public class Book implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;
    private String name;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "book")
    private BookDetail bookDetail;


}



@Entity
@Table(name = "book_detail")
@Data
public class BookDetail implements Serializable {

    @Id
    @OneToOne
    @JoinColumn(name = "book_id")
    private Book book;

    @Column(name = "number_of_pages")
    private Integer numberOfPages;

}


```

## 二、one-to-one-foreignkey 一对一 外键
```java
@Entity
@Data
@Table(name = "book")
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private int id;

    @Column(name = "name")
    private String name;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "book_detail_id")
//    @Lazy(false)
    private BookDetail bookDetail;


}



@Entity
@Table(name = "book_detail")
@Data
public class BookDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Integer id;

    @Column(name = "number_of_pages")
    private Integer numberOfPages;

    @OneToOne(mappedBy = "bookDetail")
    private Book book;
}

```

## 三、one-to-many 一对多

```java
@Entity
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;
    private String name;

    @ManyToOne
    @JoinColumn(name = "book_category_id")
    private BookCategory bookCategory;

 
}


@Entity
@Table(name = "book_category")
public class BookCategory {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;
    private String name;

    @OneToMany(mappedBy = "bookCategory", cascade = CascadeType.ALL)
    private Set<Book> books;

 

}

```



## 四、many-to-many-extra-columns 多对多中间表有额外字段

```java
@Entity
public class Book{

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;
    private String name;

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<BookPublisher> bookPublishers;

   
}


@Entity
@Table(name = "book_publisher")
public class BookPublisher implements Serializable {

    @Id
    @ManyToOne
    @JoinColumn(name = "book_id")
    private Book book;

    @Id
    @ManyToOne
    @JoinColumn(name = "publisher_id")
    private Publisher publisher;

    @Column(name = "published_date")
    private Date publishedDate;

   
}


@Entity
public class Publisher {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;
    private String name;
    @OneToMany(mappedBy = "publisher")
    private Set<BookPublisher> bookPublishers;

 
}

```

## 五、many-to-many 多对多

```java
@Entity
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;
    private String name;
    @ManyToMany(cascade = CascadeType.MERGE)
    @JoinTable(name = "book_publisher", joinColumns = @JoinColumn(name = "book_id", referencedColumnName = "id"), inverseJoinColumns = @JoinColumn(name = "publisher_id", referencedColumnName = "id"))
    private Set<Publisher> publishers = new HashSet<>();

   
}


@Entity
public class Publisher {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;
    private String name;
    @ManyToMany(mappedBy = "publishers")
    private Set<Book> books = new HashSet<>();

}

```






