
package ;

import com.punkiversal.PV;

class Utils 
{

	public static function sgn(x:Dynamic):Int
	{
		return (x > 0) ? 1 : ((x < 0) ? -1 : 0);
	}

	//Following two functions with help from Doug.McFarlane
	//http://gamedev.stackexchange.com/a/72485/25320
	public static function angleLerp(start:Dynamic, finish:Dynamic, dist:Float):Dynamic
	{
		var dForward = start - finish;
		var dBackward = finish - start;

		if (normaliseAngle(dForward) < normaliseAngle(dBackward))
		{
			if (finish < start)
			{
				finish += 360;
			}
		}
		else
		{
			if (finish > start)
			{
				finish -= 360;
			}
		}

		return normaliseAngle(PV.lerp(start, finish, dist));
	}

	public static function normaliseAngle(angle:Dynamic):Dynamic
	{
		while(angle < 0)
		{
			angle += 360;
		}
		while(angle >= 360)
		{
			angle -= 360;
		}
		return angle;
	}

	public static function gaussianRandom()
	{
		return (Math.random() + Math.random() + Math.random() + Math.random() + Math.random() + Math.random()) / 3 - 1;
	}

}