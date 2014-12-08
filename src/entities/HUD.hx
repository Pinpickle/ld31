
package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.misc.NumTween;
import scenes.GameScene;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.utils.Draw;
import com.haxepunk.HXP;
import com.haxepunk.utils.Ease;
import com.haxepunk.graphics.Text;
import flash.text.TextFormatAlign;

class HUD extends TransitionEntity
{
	private var lifeImages:Array<Image> = [];
	private var lifeX:Array<Float> = [];
	private var lifeXOld:Array<Float> = [];
	private var startTime:Float = 0;
	private var scoreText:Text;

	private var wallColour:Int;
	private var wallColourStart:Int;

	//Internal recollection of lives
	private var lives:Int;

	public function new(?x:Float, ?y:Float)
	{
		super(x, y);

		layer = -30;

		for(i in 0...Main.gameScene.maxLives)
		{
			var im:Image = Image.createRect(14, 14, 0xFFFFFF);
			im.centerOrigin();
			lifeImages.push(im);

			/*var tw:NumTween = new NumTween(null, TweenType.OneShot);
			addTween(tw);*/
			lifeX.push(GameScene.WALL_WIDTH / 2 + 20 * i);
			lifeXOld.push(0);
		}

		lives = Main.gameScene.lives;

		updateImage = false;
		

		scoreText = new Text("0", null, null, 300, 24, {
			align: TextFormatAlign.CENTER,
			resizable: false
		});
		scoreText.centerOrigin();

		colour = Main.gameScene.specialColour;
		wallColour = Main.gameScene.wallColour;
	}

	override public function update()
	{
		var col:Int = HXP.colorLerp(startColour, colour, Main.gameScene.transition);

		for (image in lifeImages)
		{
			image.color = col;
		}
	}

	override public function render()
	{
		for (i in 0...lifeImages.length)
		{
			Draw.graphic(lifeImages[i], cast HXP.lerp(lifeXOld[i], lifeX[i], Main.gameScene.transition), cast HXP.height - GameScene.WALL_WIDTH / 2, 0);
		}

		var col:Int = HXP.colorLerp(startColour, colour, Main.gameScene.transition);
		var col2:Int = HXP.colorLerp(wallColourStart, wallColour, Main.gameScene.transition);

		Draw.rectPlus(GameScene.WALL_WIDTH, GameScene.WALL_WIDTH, HXP.width - GameScene.WALL_WIDTH * 2, HXP.height - GameScene.WALL_WIDTH * 2, col2, 1, false, 2);

		var h:Int = cast HXP.lerp(0, HXP.height - GameScene.WALL_WIDTH * 2, Main.gameScene.timeLeft / Main.gameScene.timeLeftStart);
		Draw.rect(cast GameScene.WALL_WIDTH / 2 - 2, HXP.height - GameScene.WALL_WIDTH - h, 4, h, col);
		Draw.rect(cast HXP.width - GameScene.WALL_WIDTH / 2 - 2, HXP.height - GameScene.WALL_WIDTH - h, 4, h, col);

		Draw.graphic(scoreText, cast HXP.width / 2, 10, 1);
	}

	override public function setupTransition()
	{
		for (i in 0...lifeX.length)
		{
			lifeXOld[i] = lifeX[i];
			if (i < Main.gameScene.lives)
			{
				lifeX[i] = GameScene.WALL_WIDTH / 2 + i * 20;
			}
			else
			{
				lifeX[i] = HXP.height - GameScene.WALL_WIDTH / 2 - (Main.gameScene.maxLives - i) * 20;
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
	}
}