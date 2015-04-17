
package scenes;

import entities.Block;
import scenes.GameScene;
import com.punkiversal.PV;
import entities.Player;
import entities.Goal;

class LaserState extends GameState
{

	private static inline var SPACING:Int = 24;
	private var colPoints:Array<Int> = [];
	private var cols:Int;

	override public function init()
	{
		var gapWidth:Int = cast PV.lerp(10, 3, Main.gameScene.availableBlocks / Main.gameScene.blocks.length);

		var colBlocks:Int = cast (((PV.height - GameScene.WALL_WIDTH * 2) / SPACING - gapWidth) / 4);

		cols = cast Math.ceil(Math.random() * (Main.gameScene.availableBlocks / colBlocks));
		var blocks:Array<Block> = Main.gameScene.assignBlocks(cols * 4, Block.MODE_IDLE);

		for (i in 0...cols)
		{
			colPoints[i] = cast Math.floor(Math.random() * 4) + 1;
		}

		var col:Int = 0;
		var ind:Int = 0;
		var blockY:Float = PV.height - GameScene.WALL_WIDTH - SPACING / 2;
		var done:Bool = false;
		for(bigBlock in blocks)
		{
			var splitBlocks:Array<Block> = bigBlock.split(Block.MODE_IDLE);
			for (block in splitBlocks)
			{
				var x = 20 + (cols - col) * SPACING;
				block.setMode(Block.MODE_LASER);
				block.x = x;
				block.y = blockY;
				block.speed = 9;
				block.delay = 1 + col * 1.45;
				block.laserInd = col;

				if (ind + 1 == colPoints[col])
				{
					ind += gapWidth;
					blockY -= SPACING * gapWidth;
				}
				else
				{
					ind ++;
					blockY -= SPACING;
				}

				if (ind > colBlocks * 4 + gapWidth)
				{
					col ++;
					if (col >= cols)
					{
						done = true;
						break;
					}
					else
					{
						blockY = PV.height - GameScene.WALL_WIDTH - SPACING / 2;
						ind = 0;
					}
				}
			}

			if (done)
			{
				break;
			}
			
		}
	}

	override public function setGoalPosition(goal:Goal)
	{
		goal.x = 40;
		goal.y = 560;
	}

	override public function setPlayerPosition(player:Player)
	{
		player.x = 550;
		player.y = 550;
		player.changeMode(Player.MODE_PLATFORMING);
		player.jumpSpeed = -390;
		player.xSpeed = 0;
		player.ySpeed = 0;
	}

	override public function time(scene:GameScene)
	{
		return cols * 1.45 + 3.5;
	}
}