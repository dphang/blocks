include "lib://game2d/textButton.ms"
include "lib://game2d/imageButton.ms"
include "lib://game2d/sceneTransitions/slideToTop.ms"
include "lib://game2d/sceneTransitions/slideToBottom.ms"
include "app://scenes/gameScene.ms"
include "app://scenes/optionsScene.ms"

class MenuScene : Scene
{
    function init()
    {
        super.init();

        // Create buttons
        this._createPlayButton();
        this._createContinueButton();
        this._createOptionsButton();
    }

    function _createPlayButton()
    {
        // create new instanco of GameButton with images from the resources
        var button = new ImageButton({image: res.img.newgame, x:System.width/2, y: System.height / 2});
        //var button = new TextButton({text:"New Game", x:System.width/2, y:System.height/10*7});
        // set onClick event - start new game
        button.onClick = function()
        {
            game.gameScene = new GameScene();
            game.push(game.gameScene, new SlideToTop());
        }
        this.add(button);
    }

    function _createContinueButton()
    {
        // create new instanco of GameButton with images from the resources
        var button = new ImageButton({image: res.img.cont, height:res.img.cont.height * 2,  x:System.width/2, y: System.height / 2 + res.img.cont.height * 1.5});
        //var button = new TextButton({text:"Continue", x:System.width/2, y:System.height/10*8});
        // set onClick event - start new game
        button.onClick = function()
        {
            res.play(res.sounds.click);
        }
        this.add(button);
    }

    function _createOptionsButton()
    {
        // create new instanco of GameButton with images from the resources
        var button = new ImageButton({image: res.img.options, height:res.img.cont.height * 2,  x:System.width/2, y: System.height / 2 + res.img.cont.height * 3});
        // set onClick event - start new game
        button.onClick = function()
        {
            res.play(res.sounds.click);
            game.optionsScene = new OptionsScene();
            game.push(game.optionsScene, new SlideToTop());
        }
        this.add(button);
    }

    function draw(canvas)
    {
        // draw and resized background image
        canvas.drawBitmapRect(res.img.menuBg, 0, 0, res.img.menuBg.width, res.img.menuBg.height, 0, 0, System.width, System.height);

        // call parents draw function which draws all other objects
        super.draw(canvas);
    }

}
