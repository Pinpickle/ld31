
package entities;

import com.punkiversal.Entity;
import com.punkiversal.graphics.Text;
import com.punkiversal.PV;
import openfl.Assets;
import flash.geom.ColorTransform;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.geom.ColorTransform;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;

class IntroText extends TransitionEntity
{
	private var titleText:TextField;
	private var playerInfo:TextField;
	private var goalInfo:TextField;
	private var scoreInfo:TextField;

	public function new(?x:Float, ?y:Float)
	{
		super(x, y);

		var fontObj = Assets.getFont(PV.defaultFont);
		var format = new TextFormat(fontObj.fontName, 16, 0xFFFFFF);
		format.align = TextFormatAlign.CENTER;
		var bigFormat = new TextFormat(fontObj.fontName, 40, 0xFFFFFF);
		bigFormat.align = TextFormatAlign.CENTER;

		titleText = new TextField();
		titleText.defaultTextFormat = bigFormat;
		titleText.autoSize = TextFieldAutoSize.CENTER;
		titleText.text = "Blocked";
		titleText.x = (PV.width - titleText.width) / 2;
		titleText.y = 100 - titleText.height / 2;

		playerInfo = new TextField();
		playerInfo.defaultTextFormat = format;
		playerInfo.autoSize = TextFieldAutoSize.CENTER;
		playerInfo.text = "Control the player below\nwith the arrow keys and space";
		playerInfo.x = (PV.width - playerInfo.width) / 2;
		playerInfo.y = 180 - playerInfo.height / 2;

		goalInfo = new TextField();
		goalInfo.defaultTextFormat = format;
		goalInfo.autoSize = TextFieldAutoSize.CENTER;
		goalInfo.text = "Try to collect this";
		goalInfo.x = (PV.width - goalInfo.width) / 2;
		goalInfo.y = 450 - goalInfo.height / 2;

		scoreInfo = new TextField();
		scoreInfo.defaultTextFormat = format;
		scoreInfo.autoSize = TextFieldAutoSize.CENTER;
		scoreInfo.text = "Previous Score: 0\nHigh Score: 0";
		scoreInfo.x = (PV.width - scoreInfo.width) / 2;
		scoreInfo.y = 550 - scoreInfo.height / 2;

		graphic = new Sprite();
		cast(graphic, Sprite).addChild(titleText);
		cast(graphic, Sprite).addChild(playerInfo);
		cast(graphic, Sprite).addChild(goalInfo);
		cast(graphic, Sprite).addChild(scoreInfo);

		colour = PV.colorLerp(Main.gameScene.bgColour, Main.gameScene.specialColour, 0.3);

		var transform = new ColorTransform();
		transform.color = colour;
		graphic.transform.colorTransform = transform;

		updateImage = false;

		layer = 40;
	}

	public function updateScore()
	{
		scoreInfo.text = "Previous Score: " + cast (Main.gameScene.lastScore) + "\nHigh Score: " + cast (Main.gameScene.highScore);
		scoreInfo.x = (PV.width - scoreInfo.width) / 2;
		scoreInfo.y = 550 - scoreInfo.height / 2;
	}

	override public function setupTransition()
	{
		startColour = colour;
		colour = PV.colorLerp(Main.gameScene.bgColour, Main.gameScene.specialColour, 0.2);
	}
}