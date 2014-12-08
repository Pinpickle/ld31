
package scenes;

import entities.Block;
import scenes.GameScene;
import com.haxepunk.HXP;
import entities.Player;
import entities.Goal;

class PlatformsState extends GameState
{

	private var platforms:Int = 0;
	private var topX:Float;
	private var topY:Float;

	private static inline var HEIGHT_CHANGE:Int = 45;
	private static inline var HEIGHT_VAR:Int = 10;
	private static inline var SIDE_CHANGE:Int = 80;
	private static inline var SIDE_VAR:Int = 40;

	override public function init()
	{
		platforms = cast(Math.min(Math.floor(Main.gameScene.availableBlocks * Math.random()) + 1, 9), Int);

		var blocks = Main.gameScene.assignBlocks(platforms, Block.MODE_WALL);

		topX = HXP.width / 2 + Utils.gaussianRandom() * 200;
		topY = HXP.height - GameScene.WALL_WIDTH - 10;

		for (block in blocks)
		{
			newTops();

			block.x = topX;
			block.y = topY;
		}
	}

	override public function setGoalPosition(goal:Goal)
	{
		newTops();

		goal.x = topX;
		goal.y = topY - 10;
	}

	private function newTops()
	{
		topX = topX + ((topX < GameScene.WALL_WIDTH + SIDE_CHANGE) ? 1 : ((topX > HXP.width - GameScene.WALL_WIDTH - SIDE_CHANGE) ? -1 : (Math.random() < 0.5 ? 1 : -1))) * (SIDE_CHANGE + Utils.gaussianRandom() * SIDE_VAR);
		topY = topY - (HEIGHT_CHANGE + Utils.gaussianRandom() * HEIGHT_VAR);
	}

	override public function setPlayerPosition(player:Player)
	{
		player.x = 50;
		player.y = 550;
		player.changeMode(Player.MODE_PLATFORMING);
		player.jumpSpeed = -270;
		player.xSpeed = 0;
		player.ySpeed = 0;
	}

	override public function time(scene:GameScene)
	{
		return platforms * 1.3 + 2;
	}
}