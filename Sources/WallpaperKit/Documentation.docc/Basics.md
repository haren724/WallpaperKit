# Some Basics About WallpaperKit

First of all. To pass the data/url and represent our wallpapers, we need some structs. Here's the most important one:

```swift
struct WPKWallpaper {
    var project: WPKProject
    var resource: WPKResource
}
```

It contains 2 parts: `project` and `resource. `project` is prepared for representing most contents in file `project.json`, which brings us the primary information about the wallpaper, such as the `type`, `title` and `author` etc.

However, not all sections in `project.json` store in property `project`. Here it comes to the next part: `resources`, which stores all resources to be shown or rendered.

Next, we'll explain these 2 value types more concretely.

### Project

Definitions goes like this:

```swift
struct WPKProject {
    var title: String
    var preview: String
    var type: WallpaperType
    var author: String
    var tags: [String]
}

enum WallpaperType: String, Codable {
    case video, scene, application, web, other
}
```

- `title` : Wallpaper's title, not hard to understand.
- `preview` : File name of Wallpaper's preview image. Note that this string even contains the image file's extension name to determine if it's animated.
- `type` : Wallpaper's type. Mismatched type will make framework refused to parse.
- `author` : Author's name. However, we'll make it shows more details about you if you're the author of this wallpaper. So temporaily this property's type is String.
- `tags` : Used for tagging the wallpaper itself. May contain multiple strings.



### Namespace

As we all know, Swift doesn't have native support of namespace feature. However there's a way to accomplish this functionality, which may reduce a tiny little bit readability:

```swift
// MyNamespace.Person()
enum MyNamespace {
    struct Person {
        var name: String
        var age: Int
    }
}

// Person()
struct Person {
    var name: String
    var gender: String
}
```

In the example above, enum `MyNamespace` is a simulated namespace, without losing performance. You can normally treat keyword `enum` like `namespace` in supported languages like C++.

### Local Storage

For some reasons, you should notice that all structs above don't conform to `Codable` protocol. We have the `Codable` ones , which can be encoded to JSON Strings and then finally stored in local storage as a text file.

First one is `WPEngineProject`

```swift
struct WPEngineProject: Codable {
    // ...
}
```

And another one is `WPKCodableProject` 

```swift
struct Author {
    // ...
}
```



