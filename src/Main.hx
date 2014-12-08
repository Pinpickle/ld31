import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.display.StageQuality;
import scenes.GameScene;
import com.haxepunk.utils.Data;

class Main extends Engine
{

	public static var gameScene:GameScene;

	override public function init()
	{

		HXP.stage.quality = StageQuality.BEST;
		HXP.screen.smoothing = false;
#if debug
		HXP.console.enable();
		HXP.console.debug = true;
		HXP.console.debugDraw = true;
#end
		
		HXP.defaultFont = "font/emulogic.ttf";

		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("up", [Key.UP, Key.W, Key.SPACE]);
		Input.define("down", [Key.DOWN, Key.S]);

		HXP.scene = gameScene = new scenes.GameScene();

		Data.load("save");
	}

	public static function main() { new Main(); }

}