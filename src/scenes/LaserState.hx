
package scenes;

import entities.Block;
import scenes.GameScene;
import com.haxepunk.HXP;
import entities.Player;
import entities.Goal;

class LaserState extends GameState
{

	private static inline var SPACING:Int = 24;
	private var colPoints:Array<Int> = [];
	private var cols:Int;

	override public function init()
	{
		var gapWidth:Int = cast HXP.lerp(10, 3, Main.gameScene.availableBlocks / Main.gameScene.blocks.length);

		var colBlocks:Int = cast (((HXP.height - GameScene.WALL_WIDTH * 2) / SPACING - gapWidth) / 4);

		cols = cast Math.ceil(Math.random() * (Main.gameScene.availableBlocks / colBlocks));
		var blocks:Array<Block> = Main.gameScene.assignBlocks(cols * 4, Block.MODE_IDLE);

		for (i in 0...cols)
		{
			colPoints[i] = cast Math.floor(Math.random() * 4) + 1;
		}

		var col:Int = 0;
		var ind:Int = 0;
		var blockY:Float = HXP.height - GameScene.WALL_WIDTH - SPACING / 2;
		var done:Bool = false;
		for(bigBlock in blocks)
		{
			var splitBlocks:Array<Block> = bigBlock.split(Block.MODE_IDLE);
			for (block in splitBlocks)
			{
				var x = 35 + (cols - col) * SPACING;
				block.setMode(Block.MODE_LASER);
				block.x = x;
				block.y = blockY;
				block.speed = 9;
				block.delay = 1 + col * 1.2;
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
						blockY = HXP.height - GameScene.WALL_WIDTH - SPACING / 2;
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
		goal.x = 50;
		goal.y = 550;
	}

	override public function setPlayerPosition(player:Player)
	{
		player.x = 550;
		player.y = 550;
		player.changeMode(Player.MODE_PLATFORMING);
		player.jumpSpeed = -350;
		player.xSpeed = 0;
		player.ySpeed = 0;
	}

	override public function time(scene:GameScene)
	{
		return cols * 1.2 + 2;
	}
}