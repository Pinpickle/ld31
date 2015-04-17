//More of a game entity than a physics entity

package entities;

import com.punkiversal.PV;
import com.punkiversal.Entity;

class PhysicsEntity extends TransitionEntity
{

	public var xSpeed:Float = 0;
	public var ySpeed:Float = 0;

	public var stopAtSolid:Bool = false;
	public var restitution:Float = 0;

	override public function update() 
	{
		var xAdd:Float = xSpeed * PV.elapsed;
		var yAdd:Float = ySpeed * PV.elapsed;

		if ((stopAtSolid) && (collide("solid", x + xAdd, y + yAdd) != null))
		{
			//It's crude, I'm sorry
			var xSgn:Int = Utils.sgn(xAdd);
			var ySgn:Int = Utils.sgn(yAdd);

			xAdd = Math.abs(xAdd);
			yAdd = Math.abs(yAdd);

			var xFrac:Float = xAdd - Math.floor(xAdd);
			var yFrac:Float = yAdd - Math.floor(yAdd);

			var nextStep:Float;

			while(xAdd > 0) 
			{
				nextStep = xAdd < 1 ? xFrac * xSgn : xSgn;
				if (collide("solid", x + nextStep, y) == null)
				{
					x += nextStep;
					xAdd -= 1;
				}
				else
				{
					/*if (xSgn > 0)
					{
						x = Math.fceil(x);
					}
					if (xSgn < 0)
					{
						x = Math.ffloor(x);
					}*/
					xSpeed = -xSpeed * restitution;
					break;
				}
			}

			while(yAdd > 0) 
			{
				nextStep = yAdd < 1 ? yFrac * ySgn : ySgn;
				if (collide("solid", x, y + nextStep) == null)
				{
					y += nextStep;
					yAdd -= 1;
				}
				else
				{
					/*if (ySgn > 0)
					{
						y = Math.fceil(y);
					}
					if (ySgn < 0)
					{
						y = Math.ffloor(y);
					}*/
					ySpeed = -ySpeed * restitution;
					break;
				}
			}
		}
		else
		{
			x += xAdd;
			y += yAdd;
		}

		super.update();
	}
}