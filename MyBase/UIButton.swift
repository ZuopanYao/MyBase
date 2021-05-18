//
//  UIButton.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import UIKit

// MARK: - Extension UIKit - UIButton
extension UIButton {
    
    public var titleOfNormal: String? {
        get { title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }
    
    public var titleOfHighlight: String? {
        get { title(for: .highlighted) }
        set { setTitle(newValue, for: .highlighted) }
    }
    
    public var titleOfSelect: String? {
        get { title(for: .selected) }
        set { setTitle(newValue, for: .selected) }
    }
    
    public var titleOfDisable: String? {
        get { title(for: .disabled) }
        set { setTitle(newValue, for: .disabled) }
    }
    
    /// 设置标题
    ///
    /// # Parameters
    ///
    /// 1. normal: 正常状态下的标题, 这是必须的
    /// 2. highlighted: 高亮状态下的标题，保持默认，可传 nil
    /// 3. selected: 选择状态下的标题，保持默认，可传 nil
    /// 4. disabled: 禁用状态下的标题，保持默认，可传 nil
    ///
    /// # Example
    ///
    ///     let btn = UIButton()
    ///     btn.title = ("正常标题", "高亮时的标题", "选中状态标题", "禁用时标题")
    public var title: (normal: String, highlighted: String?, selected: String?, disabled: String?)? {
        get { nil }
        
        set {
            guard let value = newValue else { return }
            setTitle(value.normal, for: .normal)
            if let disabled = newValue!.disabled {
                setTitle(disabled, for: .disabled)
            }
            
            if let highlighted = value.highlighted {
                setTitle(highlighted, for: .highlighted)
            }
            
            if let selected = value.selected {
                setTitle(selected, for: .selected)
            }
        }
    }
    
    public var imageOfNormal: String {
        get { "" }
        set { setImage(newValue.image, for: .normal) }
    }
    
    public var imageOfSelect: String {
        get { "" }
        set { setImage(newValue.image, for: .selected) }
    }
    
    public var imageOfDisable: String {
        get { "" }
        set { setImage(newValue.image, for: .disabled) }
    }
    
    public var imageOfHighlight: String {
        get { "" }
        set { setImage(newValue.image, for: .highlighted) }
    }
    
    /// 设置 image
    ///
    /// # Parameters
    ///
    /// 1. normal: 正常状态下的 image, 这是必须的
    /// 2. highlighted: 高亮状态下的 image，保持默认，可传 nil
    /// 3. selected: 选择状态下的 image，保持默认，可传 nil
    /// 4. disabled: 禁用状态下的 image，保持默认，可传 nil
    ///
    /// # Example
    ///
    ///     let btn = UIButton()
    ///     btn.image = ("正常ImageName", "高亮时的ImageName", "选中状态ImageName", "禁用时ImageName")
    public var image: (normal: String, highlighted: String?, selected: String?, disabled: String?)? {
        get { nil }
        set {
            guard let value = newValue else { return }
            setImage(value.normal.image, for: .normal)
            if let disabled = value.disabled {
                setImage(disabled.image, for: .disabled)
            }
            
            if let highlighted = value.highlighted {
                setImage(highlighted.image, for: .highlighted)
            }
            
            if let selected = value.selected {
                setImage(selected.image, for: .selected)
            }
        }
    }
    
    public var titleColorOfNormal: UIColor? {
        get { titleColor(for: .normal) }
        set { setTitleColor(newValue, for: .normal) }
    }
    
    public var titleColorOfSelect: UIColor? {
        get { titleColor(for: .selected) }
        set { setTitleColor(newValue, for: .selected) }
    }
    
    public var titleColorOfHighlight: UIColor? {
        get { titleColor(for: .highlighted) }
        set { setTitleColor(newValue, for: .highlighted) }
    }
    
    public var titleColorOfDisable: UIColor? {
        get { titleColor(for: .disabled) }
        set { setTitleColor(newValue, for: .disabled) }
    }
    
    /// 设置标题颜色
    ///
    /// # Parameters
    ///
    /// 1. normal: 正常状态下的标题颜色, 这是必须的
    /// 2. highlighted: 高亮状态下的标题颜色，保持默认，可传 nil
    /// 3. selected: 选择状态下的标题颜色，保持默认，可传 nil
    /// 4. disabled: 禁用状态下的标题颜色，保持默认，可传 nil
    ///
    /// # Example
    ///
    ///     let btn = UIButton()
    ///     btn.titleColor = (.red, .blue, .black, nil)
    public var titleColor: (normal: UIColor?, highlighted: UIColor?, selected: UIColor?, disabled: UIColor?)? {
        get { nil }
        set {
            guard let value = newValue else { return }
            setTitleColor(value.normal, for: .normal)
            if let disabled = value.disabled {
                setTitleColor(disabled, for: .disabled)
            }
            
            if let highlighted = value.highlighted {
                setTitleColor(highlighted, for: .highlighted)
            }
            
            if let selected = value.selected {
                setTitleColor(selected, for: .selected)
            }
        }
    }
    
    public var backgroundImageOfNormal: String {
        get { "" }
        set { setBackgroundImage(newValue.image, for: .normal) }
    }
    
    public var backgroundImageOfSelect: String {
        get { "" }
        set { setBackgroundImage(newValue.image, for: .selected) }
    }
    
    public var backgroundImageOfHighlight: String {
        get { "" }
        set { setBackgroundImage(newValue.image, for: .highlighted) }
    }
    
    public var backgroundImageOfDisable: String {
        get { "" }
        set { setBackgroundImage(newValue.image, for: .disabled) }
    }
    
    /// 设置背景图片
    ///
    /// # Parameters
    ///
    /// 1. normal: 正常状态下的背景图片, 这是必须的
    /// 2. highlighted: 高亮状态下的背景图片，保持默认，可传 nil
    /// 3. selected: 选择状态下的背景图片，保持默认，可传 nil
    /// 4. disabled: 禁用状态下的背景图片，保持默认，可传 nil
    ///
    /// # Example
    ///
    ///     let btn = UIButton()
    ///     btn.backgroundImage = ("正常的背景图片名称", "高亮的背景图片名称", "选中状态的背景图片名称", "禁用时的背景图片名称")
    public var backgroundImage: (normal: String, highlighted: String?, selected: String?, disabled: String?)? {
        get { nil }
        set {
            guard let value = newValue else { return }
            setBackgroundImage(value.normal.image, for: .normal)
            if let disabled = value.disabled {
                setBackgroundImage(disabled.image, for: .disabled)
            }
            
            if let highlighted = value.highlighted {
                setBackgroundImage(highlighted.image, for: .highlighted)
            }
            
            if let selected = value.selected {
                setBackgroundImage(selected.image, for: .selected)
            }
        }
    }
}
