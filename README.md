# Imagebox

Imagebox is a simple Swift class to display an image in fullscreen, supports tap to zoom, zooming, panning and screen rotation.

[https://user-images.githubusercontent.com/17231825/31616106-5803ba44-b2be-11e7-9024-8e7fc6d53ba9.gif]

## Installing
Make use of the Imagebox series of files in the included project. Have not learnt how to create Pods or Carthage! Sorry!

## Usage
Create a UIButton on IB or programatically and set the image with the method, 
```
button.setImage(image: UIImage?, for: UIControlState)
```
Set up size constraint outlets for the width and height of the button and ensure your UIButton type is set to "Custom". See project for details.

Add an action to your button and call,
```
if let image = UIImage(named: imageName) {
    let controller = ImageboxController(image: image)
    controller.modalPresentationStyle = .overFullScreen
    present(controller, animated: true, completion: nil)
}
```

## Contributing
Do submit pull requests to help improve the code!

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

Originally based on hyperslo's [Lightbox](https://github.com/hyperoslo/Lightbox), reduced for single images. Includes code by,
* UIImageExtension: samewize @ [the blog](http://samwize.com/2016/06/01/resize-uiimage-in-swift/)
* Maintaining contentOffset: Kyle Redfearn @ [the blog](https://innovation.vivint.com/maintaining-content-offset-when-the-size-of-your-uiscrollview-changes-554d7742885a)
* Zoom to max:  flashfail on [Github](https://gist.github.com/TimOliver/71be0a8048af4bd86ede)
