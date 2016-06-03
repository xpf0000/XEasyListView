# XEasyListView
只需要简单设置即可实现tableview  collectionview的展示 包含上下刷新 分页  可自动计算tableviewcell的高度

开发中实际上有大量的重复性代码  比如列表展示  比如分页  每次都要去实现相同的代理 进行同质化的数据请求  如何能把这些重复性的工作压缩精简  只需要少量代码就可实现原来全部的功能 是该类库想要实现的

类库包含两个功能模块  一是数据处理模块  包含数据请求 解析成model 分页等功能  二是继承自UITableView 和 UICollectionView的两个自定义视图 实现了数据的展示以及代理方法的分发

具体使用 

    cell需要设置model属性  并在model被赋值时进行相关显示工作
    
      var model:TestModel!
      {
          didSet
          {
              ctext.preferredMaxLayoutWidth = sw-20
              ctext.text = model.content
          }
      }



        table.registerNib(UINib(nibName: "TestTableCell", bundle: nil), forCellReuseIdentifier: "TestTableCell")
        
        table.setHandle(url, pageStr: "[page]", keys: ["detail"], model: TestModel.self, CellIdentifier: "TestTableCell")
        
        table.cellHeight = 60
        
        table.show()
        
table.cellHeight这个是设定了全部的cell的高度,当然也可以不设置  也会自动计算cell的高度   

        collection.registerNib(UINib(nibName: "TestCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TestCollectionCell")
        
        collection.setHandle(url, pageStr: "[page]", keys: ["detail"], model: TestModel.self, CellIdentifier: "TestCollectionCell")
        
        collection.itemSize = CGSizeMake(sw/2.0, sw/2.0)
        
        collection.show()
        
        
项目中用到的上下拉刷新  数据请求  都是自己写的  当然也可以替换成其余的类库  没有什么影响


