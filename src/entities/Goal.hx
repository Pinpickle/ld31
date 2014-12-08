
package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Polygon;
import com.haxepunk.math.Vector;
import com.haxepunk.HXP;

class Goal extends PhysicsEntity
{

	var sprite:Image;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		graphic = sprite = Image.createRect(14, 14, 0xFFFFFF);
		sprite.centerOrigin();

		setHitbox(14, 14, 7, 7);
		type = "goal";
		colour = Main.gameScene.specialColour;
		updateImage = true;
	}

	override public function update()
	{
		sprite.color = HXP.colorLerp(startColour, colour, Main.gameScene.transition);
	}

	override public function setupTransition()
	{
		super.setupTransition();
		colour = Main.gameScene.specialColour;
	}
}