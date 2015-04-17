
package scenes;

import entities.Block;
import scenes.GameScene;
import com.punkiversal.PV;

class SpikeFieldState extends GameState
{
	override public function init()
	{
		var blocks:Array<Block> = Main.gameScene.assignBlocks(Math.round(Main.gameScene.availableBlocks * Math.random()), Block.MODE_SPIKE);

		for(block in blocks)
		{
			if (Math.random() < 0.5)
			{
				block.randomisePosition();
			}
			else
			{
				block.setMode(Block.MODE_DORMANT);
				var smallBlocks:Array<Block> = block.split(Block.MODE_SPIKE);
				for (small in smallBlocks)
				{
					small.randomisePosition();
				}
			}
		}
	}

	override public function time(scene:GameScene)
	{
		return 2 + PV.distance(scene.player.x, scene.player.y, scene.goal.x, scene.goal.y) / 80;
	}
}