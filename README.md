![Demo Snapshot]()
This is coding test for sparrow interview 
### 🖼 How to used
(1) click top left label load video, click top right label load image. 
(2) When running in simulator, draw test images and videos into iPhone's Photos. restart. running this app, then should see image and videos

## 🚀 Features
```
UIKit
MVVM pattern
```
typealias AiMachine = YOLOv3FP16
    more precise but slow
typealias AiMachine = YOLOv3TinyFP16
    faster but not very precise
### 🖼 Overlays
```
Based on MVVM pattern
    * Views
        ViewController 
            typealise choose AI engine
        have three parts
        (1) top bar
           (1.2) app title, 
           (1.1) left label,  click and load video
           (1.3) right label, click and load image
    * ViewModel
        PickerControllerDelegate
            picker up image and mp4
            analyze data by AI and send data to view
    * Model
        
    * Global
        some of global functions
```
### 🛠 Appearance / Behavior Customization
![Demo Snapshot](https://github.com/jala886/CoireML_AI/blob/main/loading%20image%20and%20show%20result.gif)

### 👀 ToDo:
    Add UITest, XCtest
    Add Combine and impove video detected
    Draw line on video and image to make result more clear
### 👀 Adapt visibility of:


### 🪄 Custom controls


## 💻 Supported Platforms

| 📱 | iOS 13+ |
| :-: | :-: |
| 🖥 | **macOS 10.15+** | 
| 📺 | **tvOS 13+** |
| ⌚️ | **watchOS 6+** |



### 📌 Annotations: The old-fashioned approach



## 🔩 Installation


## ✍️ Author

Jian Li (jason.lee.ticktick@gmail.com)

## 📄 License

