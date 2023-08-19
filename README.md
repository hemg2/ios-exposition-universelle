# 🇰🇷🇳🇴🇬🇧 만국박람회

## 📖 목차
1. [소개](#-소개)
2. [팀원](#-팀원)
3. [타임라인](#-타임라인)
4. [시각화된 프로젝트 구조](#-시각화된-프로젝트-구조)
5. [실행 화면](#-실행-화면)
6. [트러블 슈팅](#-트러블-슈팅)
7. [참고 링크](#-참고-링크)
8. [팀 회고](#-팀-회고)
</br>

## 🍀 소개
세계의 문화재중 한국의 문화재를 보여주는 만국박람회입니다.

</br>

## 👨‍💻 팀원
| redmango | hamg |
| :--------: | :--------: |
| <Img src = "https://hackmd.io/_uploads/HJ2D-DoNn.png" width="200" height="200"> |<Img src="https://user-images.githubusercontent.com/101572902/235090676-acefc28d-a358-486b-b9a6-f9c84c52ae9c.jpeg" width="200" height="200"> |
|[Github Profile](https://github.com/redmango1447) |[Github Profile](https://github.com/Hoon94) |



</br>

## ⏰ 타임라인
|날짜|내용|
|:--:|--|
|2023.06.26| JSON파일 파싱을 위한 Model 구현|
|2023.06.27| `ExpositionInfoViewController` 생성,  `scrollView` 추가 하여 Layout설정, `JSON` 파싱 진행 |
|2023.06.28| 개인 공부날이라서 그냥 지우는 방향으로??   | 
|2023.06.29| `ItemListView` 에서 `Item`의 `JSON` 파싱진행, `DetailItemViewController` 생성 및 데이터 파싱 진행 |
|2023.06.30| 파일분리, `navigationBarColor`설정, REDAME작성 |
|2023.07.03| 에러발생시 사용자에게 알리기 위한 alert추가 |
|2023.07.04| TableViewCell추가를 위한 Xib 생성 및 주입|
|2023.07.05| 기존 FormatManager구조체 NumberFormatter extention으로 수정해서 구현|
|2023.07.06| cell 오토레이아웃 지정 및 dynamic type적용|

</br>

## 👀 시각화된 프로젝트 구조

### Diagram

<p align="center">
<img width="800" src="https://github.com/hemg2/ios-exposition-universelle/assets/101572902/c9659888-36bd-450f-a8b5-ab3e53fe63f5">
</p>

</br>


## 💻 실행 화면

|    |기본 화면|dynamic Type|
|:--:|:--:|:--:|
|작동 화면| <img src="https://github.com/hemg2/ios-exposition-universelle/assets/101572902/1fc46d7f-56cb-4aab-ab09-17d7cd1016ef" width="400" height="600"/>|<img src="https://github.com/hemg2/ios-exposition-universelle/assets/101572902/71f2d9b1-c718-4138-9d3e-e32f84f09597" width="400" height="600"/>|

|가로 모드|
|:--:|
|<img src="https://github.com/hemg2/ios-exposition-universelle/assets/101572902/b7daf90f-8913-4c57-8e41-60c0b6a5ccc5" width="700" height="400"/>  |

</br>

## 🧨 트러블 슈팅

1️⃣ **Decoder가 반복 되는점**
-
🔒 **문제점** 
-  `Exposition`, `Item` 2개의 타입을 파싱을 진행 해야 합니다. 그렇기에 `이름`만다르게 데이터를 파싱을 해야하기 때문에  코드를 재사용 할 수 있게 작성을 하기위해 고민을 하게 되었습니다. 
<br>

🔑 **해결방법** 
-
```swift
extension JSONDecoder {
    func decodingContentInfo<T:Decodable>(with contentData: Data, modelType:T.Type) throws -> T {
        let decodedModel = try self.decode(T.self, from: contentData)
        
        return decodedModel
    }
}
```
- 이렇게 만들어서 어떤 타입이든 받아 그것을 파싱할 수있게 진행 하게 되었습니다. 


- 최종적으로는 이렇게 JSON 파일의 이름만을 받아함수 안에서 파싱을 진행한후 뱉어내어 만드는것이 가장 좋은 방법이라 생각을 하게 되었습니다 하지만 이것을 Model로 파일분리을 하게 되면 `import UIKit` 이 필요로하기에 UI가 없는곳에서 `import UIKit` 써야하기에 어색할 수 있습니다 이점에 대해서는 리뷰어와 소통을 통해 진행 하도록 하겠습니다.
```swift
extension JSONDecoder {
    func decodingContentInfo<T:Decodable>(_ name: String, modelType:T.Type) throws -> T {
        let name = NSDataAsset(name: name)
        let contentData = name?.data
        
        let decodedModel = try self.decode(T.self, from: contentData!)
        
        return decodedModel
    }
}
```

<br>

2️⃣ **VC간 데이터 전달**
-
🔒 **문제점**
- `ItemListViewController`에서 `DetailItemViewController`로 선택된 `cell`의 `Item`을 보내줘야 하는데 프로퍼티 또는 메소드에 직접 연결해 주입해주는 방법은 좋지 않다고 생각했습니다.

```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
        
    guard let detailItemViewController = storyboard?.instantiateViewController(identifier: "DetailItemViewController") else { return }
 
    detailItemViewController.setDetailItem(item)
    detailItemViewController.title = item.name
    
    tableView.deselectRow(at: indexPath, animated: true) 
    self.navigationController?.pushViewController(detailItemViewController, animated: true)
}
```


<br>

🔑 **해결방법**
- `DetailItemViewController`에서 `init`를 통해 인스턴스 생성시 주입해주는 방법으로 해결했습니다. 다만 스토리보드 이용시 `instantiateViewController(withIdentifier:)` 메소드로는 구현이 불가능하다고 해 검색해본 결과 iOS13 이후에 `instantiateViewController(identifier:, creator:)`이라는 메소드가 새로 나왔고 이걸 이용하면 스토리보드 이용시에도 custom init이 가능하다고하여 사용해 보았습니다.

```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
    let detailItemViewController = storyboard.instantiateViewController(identifier: "DetailItemViewController") { coder in DetailItemViewController(item: item, coder: coder) }
 
    tableView.deselectRow(at: indexPath, animated: true)
    self.navigationController?.pushViewController(detailItemViewController, animated: true)
}
```
<br>

3️⃣  **TableViewCell 내부 image 크기 오토레이아웃**
- 
🔒 **문제점**
- Cell 내부의 이미지 크기를 지정하지 않고 오토레이아웃으로만 해보라는 리뷰어의 요구사항에 따라 시도 해보았으나 이미지 크기가 제대로 정해지지 않고 중구난방으로 크기가 제각각 달랐습니다.

- 처음 Label끼리 스택뷰를 묶고 이미지뷰는 따로 스택뷰 없이 진행을 하였습니다. 이렇게 될경우 Label에 의해서 cell의 높이가 동적으로 지정이 될 줄 알았지만 ImageView를 우선으로 잡히는 거같았습니다. 더하여 ImageView의 이미지들이 크기가 달랐기에 셀의 크기를 맞출수가 없었습니다. 

<br>

🔑 **해결방법**
- 그래서 이미지뷰와 레이블묶음을 한번 더 스택뷰를 묶어서 레이아웃 설정을 진행했습니다. 전체(뷰와레이블)스택뷰를 셀 크기에 맞춰 진행하였고 이미지 뷰를 스택뷰 비율을 맞춰 셀 크기에 따라 이미지 크기를 정하게 할 수 있게끔 진행하였습니다. 
- 이러한 크기를 갖게되는 경우도 생기게 되었고 이 부분에 있어 스택뷰 바텀부분을 Equal -> Greater Than or Equal로 진행하여 남기는 부분이 없게끔 진행 하였습니다.



| 셀의문제 | 해결진행 |
| :--------: | :--------: |
|<Img src = "https://hackmd.io/_uploads/rJpRWNrF2.png" width="300" height="600">|<Img src = "https://hackmd.io/_uploads/rJOrPVEth.png" width="300" height="600"> |
<br>

4️⃣ **화면 회전시 ScrollView **
-
🔒 **문제점**
- 화면 회전시 ScrollView의 위치가 제대로 잡히지 않는 점을 파악했습니다.

![](https://hackmd.io/_uploads/H1UcjXBF2.png)

<br>

🔑 **해결방법**
- ScrollView의 레이아웃을 최상위 뷰와 일치시키지 않아 생긴 문제로 레이아웃을 일치 시키자 해결 되었습니다.

![](https://hackmd.io/_uploads/rkQNhQHK2.png)

<br>

5️⃣ **3세대 아이폰 화면에서 ScrollView **
-
🔒 **문제점**
- 3세대 아이폰 시뮬레이터에서 실행시 메인화면의 button이 하단 홈 바에 가려지는 문제가 발견되었습니다.
<img src="https://hackmd.io/_uploads/Hkod0XHF2.png" width="300" height="600"/> 

<br>

🔑 **해결방법**
- ScrollView의 Frame 레이아웃이 view와 일치하지 않고 하단으로 더 커서 생긴 문제로 해당 문제를 수정하자 해결 되었습니다.

<img src="https://hackmd.io/_uploads/HJSqkNSFh.png" width="300" height="600"/> 


<br>

## 📚 참고 링크

[스토리보드에서 custom initializer구현할때](https://developer.apple.com/documentation/uikit/uistoryboard/3213989-instantiateviewcontroller)
</br>
[🍎Apple Docs: UITableView](https://developer.apple.com/documentation/uikit/uitableview)
</br>
[🍎Apple Docs: Table views](https://developer.apple.com/documentation/uikit/views_and_controls/table_views)
</br>
[🍎Apple Docs: JSONDecoder](https://developer.apple.com/documentation/foundation/jsondecoder)
</br>

## 👥 팀 회고
## 우리팀이 잘한 점
- 프로젝트 진행과정에 있어 만족감을 느끼면서 프로젝트를 진행함
- 덜하지도 과하지도 않게 진행하여 좋았다.
## 서로에게 좋았던 점 피드백
- redmango to hamg
    해결 될때까지 진득하니 붙잡고 있는 점이 좋았습니다.
- hamg to redmango
    한번 더 생각하게 시간을 갖는점이 좋았다    
## 서로에게 하고싶은 말
- redmango to hamg
    편안한 팀프로젝트 좋았습니다
- hamg to redmango
    야곰닷넷 오토레이아웃 진행 하겠습니다
