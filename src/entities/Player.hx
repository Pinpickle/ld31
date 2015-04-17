package entities;

import flash.display.Shape;
import flash.geom.ColorTransform;
import com.punkiversal.Entity;
import com.punkiversal.graphics.Image;
import com.punkiversal.PV;
import com.punkiversal.utils.Input;
import com.punkiversal.utils.Draw;
import com.punkiversal.Sfx;

class Player extends PhysicsEntity
{
	public var mode:Int;
	public var jumpSpeed:Int = -270;
	public var platformAcc:Float = 1000;
	public var platformDeacc:Float = 3000;
	public var platformAirFactor:Float = 0.8;
	public var platformMaxSpeed:Float = 250;

	public static inline var MODE_FREE_MOVEMENT:Int = 0;
	public static inline var MODE_PLATFORMING:Int = 1;

	public static inline var PLAYER_SIZE:Int = 14;

	public static var jumpSfx:Sfx;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		stopAtSolid = true;

		setHitbox(PLAYER_SIZE, PLAYER_SIZE, cast(PLAYER_SIZE / 2, Int), cast(PLAYER_SIZE / 2, Int));

		type = "player";

		changeMode(MODE_FREE_MOVEMENT);
		colour = Main.gameScene.specialColour;

		jumpSfx = new Sfx("audio/jump.mp3");
		jumpSfx.type = "sound";

		graphic = new Shape();
		cast(graphic, Shape).graphics.beginFill(colour, 1);
		cast(graphic, Shape).graphics.drawRect(-PLAYER_SIZE / 2, -PLAYER_SIZE / 2, PLAYER_SIZE, PLAYER_SIZE);

		graphic.transform.colorTransform = new ColorTransform();
	}

	override public function update()
	{
		switch (mode) 
		{
			case MODE_FREE_MOVEMENT:
				freeMovementControl();
			case MODE_PLATFORMING:
				platformingControl();
		}

		if (collide("goal", x, y) != null)
		{
			Main.gameScene.win();
		}

		if (collide("death", x, y) != null)
		{
			Main.gameScene.lose();
		}

		super.update();
	}

	public function changeMode(m:Int)
	{
		mode = m;
		switch(mode)
		{
			case MODE_FREE_MOVEMENT:
				restitution = 0.9;
			case MODE_PLATFORMING:
				restitution = 0;
		}
		colour = Main.gameScene.specialColour;
	}

	/*override public function render()
	{
		// Draw.rectPlus(lerpX() - PLAYER_SIZE / 2, lerpY() - PLAYER_SIZE / 2, PLAYER_SIZE, PLAYER_SIZE, PV.colorLerp(startColour, colour, Main.gameScene.transition), 1, false, 2);
	}*/

	private function freeMovementControl()
	{
		if (Input.check("left"))
		{
			xSpeed -= 1000 * PV.elapsed;
		}

		if (Input.check("right"))
		{
			xSpeed += 1000 * PV.elapsed;
		}

		if (Input.check("up"))
		{
			ySpeed -= 1000 * PV.elapsed;
		}

		if (Input.check("down"))
		{
			ySpeed += 1000 * PV.elapsed;
		}

		xSpeed *= 0.97;
		ySpeed *= 0.97;
	}

	private function platformingControl()
	{
		var onGround:Bool = (collide("solid", x, y + 3) != null);
		var factor:Float = onGround ? 1 : platformAirFactor;
		if (Input.check("left"))
		{
			xSpeed -= platformAcc * PV.elapsed * factor;
		}

		if (Input.check("right"))
		{
			xSpeed += platformAcc * PV.elapsed * factor;
		}

		if ((!(Input.check("left"))) && (!(Input.check("right"))))
		{
			if (Math.abs(xSpeed) > PV.elapsed * platformDeacc * factor)
			{
				xSpeed -= Utils.sgn(xSpeed) * PV.elapsed * platformDeacc * factor;
			}
			else
			{
				xSpeed = 0;
			}
		}

		if ((Input.pressed("up")) && (onGround))
		{
			ySpeed = jumpSpeed;
			jumpSfx.play(0.7);
		}

		ySpeed += 600 * PV.elapsed;

		if (Math.abs(xSpeed) > platformMaxSpeed)
		{
			xSpeed = Utils.sgn(xSpeed) * platformMaxSpeed;
		}


	}


}