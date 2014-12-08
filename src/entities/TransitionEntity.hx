
package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;

class TransitionEntity extends Entity
{
	private var startX:Float = 0;
	private var startY:Float = 0;
	private var startColour:Int = 0;
	private var startRotation:Float = 0;
	public var updateImage:Bool = true;

	public var colour:Int = 0;
	public var rotation:Float = 0;


	override public function update()
	{
		if ((updateImage) && (graphic != null))
		{
			cast(graphic, Image).color = HXP.colorLerp(startColour, colour, Main.gameScene.transition);
			cast(graphic, Image).angle = Utils.angleLerp(startRotation, rotation, Main.gameScene.transition);
		}

		super.update();
	}

	override public function render()
	{
		if ((graphic != null) && (graphic.visible))
		{
			Draw.graphic(graphic, cast(lerpX(), Int), cast(lerpY(), Int), 0);
		}
	}

	public function setupTransition()
	{
		startRotation = rotation;
		startColour = colour;
		startX = x;
		startY = y;
	}

	public function newValues()
	{
		
	}

	public function lerpX():Float
	{
		return HXP.lerp(startX, x, Main.gameScene.transition);
	}

	public function lerpY():Float
	{
		return HXP.lerp(startY, y, Main.gameScene.transition);
	}
	

}