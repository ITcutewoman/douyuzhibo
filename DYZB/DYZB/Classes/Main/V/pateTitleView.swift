//
//  pateTitleView.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/20.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit
fileprivate let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)
protocol pateTitleViewDelegate : class{
    func pageTitleView(_ titleView : pateTitleView, selectedIndex  index : Int)
}
class pateTitleView: UIView {
    fileprivate var currentIndex : Int = 0
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    //自定义构造函数
    fileprivate var titles : [String]
    weak var delegate : pateTitleViewDelegate?
    //添加滑动视图
    fileprivate lazy var scrollView : UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        scrollView.bounces = false
        return scrollView
    }()
    fileprivate lazy var scrollLine : UIView = {
       let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    init(frame: CGRect,titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension pateTitleView{
    fileprivate func setupUI(){
        //1.添加滑动视图
        addSubview(scrollView)
       scrollView.frame = bounds
        
        //2. 添加labels
        setupTitleLabels()
        
        //3.设置底部的线
        setupBottomLine()
    }
    private func setupTitleLabels(){
        let labelW : CGFloat = frame.width/CGFloat(titles.count)
        let labelH :CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        for (index,title) in titles.enumerated(){
            //1.创建label
            let label = UILabel()
            label.text = title
            label.tag = index
            label.textColor = UIColor.gray
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textAlignment = .center
            
            //2.设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            //5.给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomLine(){
        //1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor .lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: kScreenW, height: lineH)
        addSubview(bottomLine)
        
        //2.添加scrollline
        //2.1获取第一个label
        guard let firstLabel = titleLabels.first else { return  }
        firstLabel.textColor = UIColor.orange
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}

//MARK : - 监听label的点击
extension pateTitleView{
    @objc fileprivate func titleLabelClick(_ tap : UITapGestureRecognizer){
        //1.获取当前的label
        guard  let currentLabel =  tap.view as? UILabel else{ return}
        
        //2.获取之前的label
        let oldLabel = titleLabels[currentIndex];
        
        currentLabel.textColor = UIColor.orange
        oldLabel.textColor = UIColor.gray
        
        //3. 记录最新的下标值
         currentIndex =  currentLabel.tag
        
        //4.滚动条滚动到相应的位置
        let scrollLineX = CGFloat(currentIndex)*scrollLine.frame.width
        UIView.animate(withDuration: 0.15 ,animations:{
            self.scrollLine.frame.origin.x = scrollLineX
        })
        //5.通知代理，让pagecontentview接收到当前index
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
    }
}


//MARK: - 对外暴露的方法
extension pateTitleView{
    func setTitleViewProgress(_ progress : CGFloat, sourceIndex : Int ,target : Int) {
        //1.去除sourceLabel / targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[target]
        
        //2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3.改变sourcelabel和targetlabel的颜色，渐变
        
        //3.1渐变的颜色范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0,kSelectColor.1 - kNormalColor.1,kSelectColor.2 - kNormalColor.2)
        
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
         targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        //记录最新的index
        //滑动contentview之后会改变当前的index
        currentIndex = target
    }
}
