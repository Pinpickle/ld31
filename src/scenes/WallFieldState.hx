
package scenes;

import entities.Block;
import scenes.GameScene;
import com.haxepunk.HXP;

class WallFieldState extends GameState
{
	override public function init()
	{
		var blocks:Array<Block> = Main.gameScene.assignBlocks(Main.gameScene.availableBlocks, Block.MODE_WALL);

		for(block in blocks)
		{
			block.randomisePosition();
		}
	}

	override public function time(scene:GameScene)
	{
		return 2 + HXP.distance(scene.player.x, scene.player.y, scene.goal.x, scene.goal.y) / 150;
	}
}