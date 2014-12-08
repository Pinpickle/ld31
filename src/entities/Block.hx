
package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import scenes.GameScene;
import com.haxepunk.utils.Draw;
import com.haxepunk.tweens.motion.CircularMotion;
import com.haxepunk.Tween.TweenType;

class Block extends entities.PhysicsEntity
{
	public static inline var MODE_DORMANT:Int = -1;
	public static inline var MODE_IDLE:Int = 0;
	public static inline var MODE_WALL:Int = 1;
	public static inline var MODE_SPIKE:Int = 2;
	public static inline var MODE_LASER:Int = 3;

	private var colourMode = 0;

	public var mode:Int = 0;
	public var size:Int = 0;

	public var splitBlocks:Array<Block> = [];
	public var splitState:Int = 0;
	//-1 for gone 0 for nothing, 1 for split, 2 for coming back together, 3 for being part of something that is coming back together

	private var circleTween:CircularMotion = new CircularMotion(null, TweenType.Looping);

	private var sprite:Image;

	//Laser mode
	public var delay:Float = 0;
	public var speed:Float = 0;
	public var laserInd:Int = 0;

	public function new (x:Float, y:Float, size:Int = 1)
	{
		super(x, y);
		this.size = size;

		var circleX = Math.random() * HXP.width;
		var circleY = Math.random() * HXP.height;
		var circleRadius = Math.random() * (Math.min(Math.min(circleX, HXP.width - circleX), Math.min(circleY, HXP.width - circleY)) - 5) + 5;

		circleTween.setMotionSpeed(circleX, circleY, circleRadius, Math.random() * 360, Math.random() < 0.5, Math.random() * 20 + 5);
		addTween(circleTween, true);

		sprite = Image.createRect(cast(20 / size, Int), cast(20 / size, Int), 0xFFFFFF);
		sprite.centerOrigin();

		graphic = sprite;

		setHitbox(cast(20 / size, Int), cast(20 / size, Int), cast(10 / size, Int), cast(10 / size, Int));

		if (size == 1)
		{
			for(i in 0...4)
			{
				var block:Block = new Block(0, 0, size + 1);

				block.visible = false;
				block.splitState = -1;
				splitBlocks.push(new Block(0, 0, size + 1));
			}
		}

		setMode(MODE_DORMANT);
	}

	override public function update()
	{
		super.update();

		//When split cubes are coming back together
		if (splitState == 2)
		{
			if (Main.gameScene.resetting)
			{
				var ind:Int = 0;
				for (block in splitBlocks)
				{
					subBlockPosition(block, ind);

					block.rotation = rotation;
					block.colour = colour;
					ind ++;
				}
			}
			else
			{
				for (block in splitBlocks)
				{
					block.visible = false;
					block.splitState = -1;
					Main.gameScene.remove(block);
				}
				visible = true;
				splitState = 0;
			}
		}

		if (splitState != 3)
		{
			switch(mode)
			{
				case MODE_IDLE:
					x = circleTween.x;
					y = circleTween.y;
				case MODE_SPIKE:
					rotation += 90 * HXP.elapsed;
				case MODE_LASER:
					rotation += 90 * HXP.elapsed;
					if (delay > 0)
					{
						delay -= HXP.elapsed;
					}
					else if (x < HXP.width - GameScene.WALL_WIDTH - 20 - 20 * laserInd)
					{
						x += speed;
					}
					
			}
		}
	}

	public function setMode(m:Int)
	{
		mode = m;

		switch (mode)
		{
			case MODE_DORMANT:
				type = "";
				layer = 10;
				rotation = 0;
				colour = HXP.colorLerp(Main.gameScene.bgColour, Main.gameScene.specialColour, 0.2);
			case MODE_IDLE:
				type = "";
				layer = 1;
				colour = HXP.colorLerp(Main.gameScene.bgColour, Main.gameScene.specialColour, 0.4);
			case MODE_WALL:
				graphic.visible = true;
				colour = Main.gameScene.wallColour;
				layer = 1;
				rotation = 0;
				type = "solid";
			case MODE_SPIKE:
				graphic.visible = true;
				colour = Main.gameScene.deathColour;
				layer = 1;
				rotation = Math.random() * 360;
				type = "death";
			case MODE_LASER:
				graphic.visible = true;
				colour = Main.gameScene.deathColour;
				layer = 1;
				rotation = Math.random() * 360;
				type = "death";
		}
	}

	public function split(?mode:Int):Array<Block>
	{
		type = "";
		visible = false;
		var ind:Int = 0;

		for (block in splitBlocks)
		{
			block.visible = true;
			if (block.splitState == -1)
			{	
				subBlockPosition(block, ind, true);
				block.rotation = rotation;
				block.startRotation = rotation;
				block.colour = colour;
				block.startColour = colour;

				block.setupTransition();
			}

			block.splitState = 0;

			if (mode != null)
			{
				block.setMode(mode);
			}

			Main.gameScene.add(block);

			ind ++;
		}

		splitState = 1;

		return splitBlocks;
	}

	public function unSpilt()
	{
		if (splitState == 1)
		{
			for (block in splitBlocks)
			{
				block.splitState = 3;
				block.type = "";
			}

			splitState = 2;
		}
	}

	//http://stackoverflow.com/questions/620745/c-rotating-a-vector-around-a-certain-point
	private function subBlockPosition(block:Block, ind:Int, old:Bool = false)
	{
		var xVec:Float = (((ind == 1) || (ind == 2)) ? 1 : -1) * width / 4;
		var yVec:Float = ((ind > 1) ? 1 : -1) * width / 4;
		var ang:Float = rotation * HXP.RAD,
			cos:Float = Math.cos(ang),
			sin:Float = Math.sin(ang);

		block.x = x + (xVec * cos) + (yVec * sin);
		block.y = y - (yVec * cos) + (xVec * sin);

		if (old)
		{
			block.startX = block.x;
			block.startY = block.y;
		}
	}

	public function randomisePosition()
	{
		do
		{
			x = Math.random() * (HXP.width - GameScene.WALL_WIDTH * 2 - 20) + GameScene.WALL_WIDTH + 10;
			y = Math.random() * (HXP.height - GameScene.WALL_WIDTH * 2 - 20) + GameScene.WALL_WIDTH + 10;
		}
		while ((collide("player", x, y) != null) || (collide("goal", x, y) != null));
	}
}