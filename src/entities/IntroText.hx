
package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.utils.Draw;
import flash.text.TextFormatAlign;

class IntroText extends TransitionEntity
{
	private var titleText:Text;
	private var playerInfo:Text;
	private var goalInfo:Text;
	private var scoreInfo:Text;

	public function new(?x:Float, ?y:Float)
	{
		super(x, y);
		
		titleText = new Text("Blocked", {
			size: 40,
		});
		titleText.centerOrigin();

		playerInfo = new Text("Control the player below\nwith the arrow keys and space", {
			align: TextFormatAlign.CENTER
		});
		playerInfo.centerOrigin();

		goalInfo = new Text("Try to collect this", {
			align: TextFormatAlign.CENTER
		});
		goalInfo.centerOrigin();

		scoreInfo = new Text("Previous Score: 0\nHigh Score: 0", {
			align: TextFormatAlign.CENTER
		});
		scoreInfo.centerOrigin();

		colour = HXP.colorLerp(Main.gameScene.bgColour, Main.gameScene.specialColour, 0.3);

		updateImage = false;

		layer = 40;
	}

	override public function update()
	{
		var col:Int = HXP.colorLerp(startColour, colour, Main.gameScene.transition);
		
		titleText.color = col;
		playerInfo.color = col;
		goalInfo.color = col;
		scoreInfo.color = col;
	}

	override public function render()
	{
		var xx:Int = cast HXP.width / 2;
		Draw.graphic(titleText, xx, 100);
		Draw.graphic(playerInfo, xx, 180);
		Draw.graphic(goalInfo, xx, 450);
		Draw.graphic(scoreInfo, xx, 550);
	}

	public function updateScore()
	{
		scoreInfo.text = "Previous Score: " + cast (Main.gameScene.lastScore) + "\nHigh Score: " + cast (Main.gameScene.highScore);
	}

	override public function setupTransition()
	{
		startColour = colour;
		colour = HXP.colorLerp(Main.gameScene.bgColour, Main.gameScene.specialColour, 0.2);
	}
}