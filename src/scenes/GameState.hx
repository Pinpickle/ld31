
package scenes;

import com.punkiversal.math.Vector;
import com.punkiversal.PV;
import scenes.GameScene;
import entities.Player;
import entities.Goal;

class GameState 
{

	public function new()
	{

	}

	public function init()
	{

	}

	public function time(scene:GameScene):Float
	{
		return 10;
	}

	public function setGoalPosition(goal:Goal)
	{
		do
		{
			goal.x = Math.random() * (PV.width - GameScene.WALL_WIDTH * 2) + GameScene.WALL_WIDTH;
			goal.y = Math.random() * (PV.height - GameScene.WALL_WIDTH * 2) + GameScene.WALL_WIDTH;
		}
		while (goal.collide("wall", goal.x, goal.y) != null);
	}

	public function setPlayerPosition(player:Player)
	{
		player.changeMode(Player.MODE_FREE_MOVEMENT);
	}
}