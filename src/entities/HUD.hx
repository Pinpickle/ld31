
package entities;

import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.geom.ColorTransform;
import openfl.Assets;
import com.punkiversal.Entity;
import com.punkiversal.tweens.misc.NumTween;
import scenes.GameScene;
import com.punkiversal.Tween.TweenType;
import com.punkiversal.PV;
import com.punkiversal.utils.Ease;
import com.punkiversal.graphics.Text;
import flash.text.TextFormatAlign;

class HUD extends TransitionEntity
{
	private var lifeImages:Array<Shape> = [];
	private var lifeX:Array<Float> = [];
	private var lifeXOld:Array<Float> = [];
	private var startTime:Float = 0;
	private var scoreText:TextField;
	private var timerShape:Shape;

	private var wallColour:Int;
	private var wallColourStart:Int;

	private var HUDGraphics:Sprite;
	private var wallGraphics:Sprite;

	//Internal recollection of lives
	private var lives:Int;

	public function new(?x:Float, ?y:Float)
	{
		super(x, y);
		graphic = new Sprite();

		HUDGraphics = new Sprite();
		wallGraphics = new Sprite();

		HUDGraphics.transform.colorTransform = new ColorTransform();
		wallGraphics.transform.colorTransform = new ColorTransform();

		cast(graphic, Sprite).addChild(HUDGraphics);
		cast(graphic, Sprite).addChild(wallGraphics);

		layer = -30;

		for(i in 0...Main.gameScene.maxLives)
		{
			var im:Shape = new Shape();

			im.graphics.beginFill(0xFFFFFF);
			im.graphics.drawRect(-7, -7, 14, 14);
			im.y = PV.height - GameScene.WALL_WIDTH / 2;
			lifeImages.push(im);
			HUDGraphics.addChild(im);

			lifeX.push(GameScene.WALL_WIDTH + 7 + 20 * i);
			lifeXOld.push(0);
		}

		lives = Main.gameScene.lives;

		timerShape = new Shape();
		HUDGraphics.addChild(timerShape);

		updateImage = false;
		
		var fontObj = Assets.getFont(PV.defaultFont);
		var format = new TextFormat(fontObj.fontName, 16, 0xFFFFFF);
		format.align = TextFormatAlign.CENTER;

		scoreText = new TextField();
		scoreText.defaultTextFormat = format;
		scoreText.text = "0";

		scoreText.x = PV.width / 2;
		scoreText.y = -2;

		HUDGraphics.addChild(scoreText);

		var wall:Shape = new Shape();
		wall.graphics.lineStyle(2, 0xFF0000);
		wall.graphics.drawRect(GameScene.WALL_WIDTH - 1, GameScene.WALL_WIDTH - 1, PV.width - GameScene.WALL_WIDTH * 2, PV.height - GameScene.WALL_WIDTH * 2);

		wallGraphics.addChild(wall);

		colour = Main.gameScene.specialColour;
		wallColour = Main.gameScene.wallColour;
	}

	override public function render()
	{
		var col:ColorTransform = HUDGraphics.transform.colorTransform;
		col.color = PV.colorLerp(startColour, colour, Main.gameScene.transition);
		HUDGraphics.transform.colorTransform = col;
		scoreText.transform.colorTransform = col;

		col.color = PV.colorLerp(wallColourStart, wallColour, Main.gameScene.transition);
		wallGraphics.transform.colorTransform = col;

		for (i in 0...lifeImages.length)
		{
			lifeImages[i].x = PV.lerp(lifeXOld[i], lifeX[i], Main.gameScene.transition);
		}

		var h:Int = cast PV.lerp(0, PV.height - GameScene.WALL_WIDTH * 2, Main.gameScene.timeLeft / Main.gameScene.timeLeftStart);
		timerShape.graphics.clear();
		timerShape.graphics.beginFill(0x000000);
		timerShape.graphics.drawRect(GameScene.WALL_WIDTH / 2 - 2, PV.height - GameScene.WALL_WIDTH - h, 4, h);
		timerShape.graphics.drawRect(PV.width - GameScene.WALL_WIDTH / 2 - 2, PV.height - GameScene.WALL_WIDTH - h, 4, h);
	}

	override public function setupTransition()
	{
		for (i in 0...lifeX.length)
		{
			lifeXOld[i] = lifeX[i];
			if (i < Main.gameScene.lives)
			{
				lifeX[i] = GameScene.WALL_WIDTH + 7 + i * 20;
			}
			else
			{
				lifeX[i] = PV.width - GameScene.WALL_WIDTH / 2 - (Main.gameScene.maxLives - i) * 20;
			}
		}
		startColour = colour;
		wallColourStart = wallColour;

		colour = Main.gameScene.specialColour;
		wallColour = Main.gameScene.wallColour;
	}

	public function updateScore()
	{
		scoreText.text = cast Main.gameScene.score;
		scoreText.x = PV.width / 2 - scoreText.width / 2;
	}
}