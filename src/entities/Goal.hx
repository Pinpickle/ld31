
package entities;

import flash.display.Shape;
import com.punkiversal.Entity;
import com.punkiversal.graphics.Image;
import com.punkiversal.masks.Polygon;
import com.punkiversal.math.Vector;
import com.punkiversal.PV;

class Goal extends PhysicsEntity
{

	var sprite:Shape;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		graphic = sprite = new Shape();
		sprite.graphics.lineStyle(2, Main.gameScene.specialColour);
		sprite.graphics.drawRect(-7, -7, 14, 14);

		setHitbox(14, 14, 7, 7);
		type = "goal";
		colour = Main.gameScene.specialColour;
		updateImage = true;
	}

	override public function update()
	{
		//sprite.color = PV.colorLerp(startColour, colour, Main.gameScene.transition);
	}

	override public function setupTransition()
	{
		super.setupTransition();
		colour = Main.gameScene.specialColour;
	}
}