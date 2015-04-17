
package entities;

import com.punkiversal.Entity;
import com.punkiversal.PV;
import com.punkiversal.graphics.Image;
import com.punkiversal.utils.Draw;

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
		/*if ((updateImage) && (graphic != null))
		{
			cast(graphic, Image).color = PV.colorLerp(startColour, colour, Main.gameScene.transition);
			cast(graphic, Image).angle = Utils.angleLerp(startRotation, rotation, Main.gameScene.transition);
		}*/

		super.update();
	}

	override public function render()
	{
		if (graphic != null) {
			graphic.x = cast(lerpX(), Int);
			graphic.y = cast(lerpY(), Int);
			
			var col = graphic.transform.colorTransform;
			col.color = PV.colorLerp(startColour, colour, Main.gameScene.transition);
			graphic.transform.colorTransform = col;
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
		return PV.lerp(startX, x, Main.gameScene.transition);
	}

	public function lerpY():Float
	{
		return PV.lerp(startY, y, Main.gameScene.transition);
	}
	

}