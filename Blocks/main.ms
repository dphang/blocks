include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "app://resources.ms"
include "app://scenes/menuScene.ms"
include "app://options.ms"

// create new game instance
var game = new Game();
// load resources instance
var res = new Resources();

// prepare game instance before it runs
game.onStart = function()
{

    // create menu scene
    this.menu = new MenuScene();
    this.push(this.menu);
    // game scene will be in game variable
    this.game = null;
}

// reaction to hardware keyboard press
game.onKeyPressed = function(keyCode)
{
    if (keyCode == #back || keyCode == #home)
        app.quit();
}

// run the game
game.run(true);
