package scenes;

import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.masks.Masklist;
import com.haxepunk.masks.Hitbox;
import entities.Player;
import entities.Block;
import com.haxepunk.HXP;
import entities.Goal;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.utils.Ease;
import entities.HUD;
import entities.IntroText;
import com.haxepunk.utils.Data;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class GameScene extends Scene
{

	public var walls:Entity;

	public var blocks:Array<Block>;
	public var availableBlocks:Int = 0;
	public var reservedBlocks:Int = 0;

	public var goal:Goal;
	public var player:Player;
	public var hud:HUD;
	public var introText:IntroText;

	public var lives:Int = 3;
	public var maxLives:Int = 2;

	public var states:Array<GameState>;
	public var gameState:GameState;

	public var resetting:Bool = false;
	public var stateTween:VarTween;
	public var transition:Float = 1;

	public var wallColour = 0x0000FF;
	public var deathColour = 0xFF0000;
	public var specialColour = 0xFFFFFF;
	public var bgColour = 0x00FF00;
	public var oldBgColour = 0x00FF00;

	private var blockCols:Int = 6;
	private var blockRows:Int = 6;

	public var timeLeft:Float = 1;
	public var timeLeftStart:Float = 1;
	public var started:Bool = false;

	public var highScore:Int = 0;
	public var lastScore:Int = 0;

	public var score:Int = 0;

	public static var winSound:Sfx;
	public static var loseSound:Sfx;
	public static var finalSound:Sfx;
	public static var music:Sfx;

	public static var muted:Bool = false;

	public static inline var WALL_WIDTH:Int = 24;

	//Background, wall, death, special
	public static var colours:Array<Array<Int>> = [
		[0xB8D917, 0x25374C, 0x732810, 0x000000],
		[0x05301E, 0x865199, 0xAD8732, 0xFFFFFF],
		[0xE0DD57, 0x8270E4, 0x6A7A60, 0x000000],
		[0x3B464C, 0x57E0CA, 0xE49D92, 0xFFFFFF]
	];

	public override function begin()
	{
		chooseColour();
		HXP.screen.color = bgColour;
		stateTween = new VarTween(tweenComplete, TweenType.Persist);
		addTween(stateTween, false);

		player = new entities.Player(HXP.width / 2, HXP.height / 2);
		add(player);

		walls = new Entity(0, 0);

		//Looks like hitboxes are offset in HaxePunk so this is compensation
		var wallMask:Masklist = new Masklist([
			new Hitbox(WALL_WIDTH, HXP.height, cast(WALL_WIDTH / 2, Int)),
			new Hitbox(HXP.width, WALL_WIDTH, 0, cast(WALL_WIDTH / 2, Int)),
			new Hitbox(WALL_WIDTH, HXP.height, HXP.width - cast(WALL_WIDTH / 2, Int)),
			new Hitbox(HXP.width, WALL_WIDTH, 0, HXP.height - cast(WALL_WIDTH / 2, Int))
		]);

		walls = new Entity();
		walls.type = "solid";
		walls.mask = wallMask;

		add(walls);

		//Add blocks
		var tempBlocks:Array<Block> = new Array<Block>();

		for(i in 0...(blockCols))
		{
			for (n in 0...(blockRows)) 
			{
				var e:Block = new Block(0, 0);

				tempBlocks.push(e);
				add(e);
			}
		}

		hud = new HUD();
		add(hud);

		//blocks = tempBlocks;
		blocks = shuffleBlockArray(tempBlocks);

		//Add goal
		goal = new Goal(100, 100);
		add(goal);

		introText = new IntroText(0, 0);
		add(introText);

		//Initialise game states
		states = new Array<GameState>();
		states.push(new WallFieldState());
		states.push(new SpikeFieldState());
		states.push(new scenes.PlatformsState());
		states.push(new scenes.LaserState());

		//availableBlocks = 20;

		init();

		muted = Data.readBool("muted", false);
		Sfx.setVolume("sound", muted ? 0 : 1);

		winSound = new Sfx("audio/collect.mp3");
		winSound.type = "sound";
		loseSound = new Sfx("audio/lose.mp3");
		loseSound.type = "sound";
		finalSound = new Sfx("audio/finish.mp3");
		finalSound.type = "sound";
		music = new Sfx("audio/music.mp3");
		music.type = "sound";

		music.loop(0.8);

		highScore = Data.readInt("highScore", 0);
		lastScore = Data.readInt("lastScore", 0);
	}

	public function init()
	{
		player.x = HXP.width / 2;
		player.y = HXP.height / 2;
		player.changeMode(Player.MODE_FREE_MOVEMENT);
		player.xSpeed = 0;
		player.ySpeed = 0;

		goal.x = HXP.width / 2;
		goal.y = 500;

		chooseColour();

		var blockSpacing = 30;
		var ind:Int = 0;
		for(i in 0...(blockCols))
		{
			for (n in 0...(blockRows)) 
			{
				var block:Block = blocks[ind];
				block.x = HXP.width / 2 + (i - blockCols / 2 + 0.5) * blockSpacing;
				block.y = HXP.height / 2 + (n - blockRows / 2 + 0.5) * blockSpacing;

				ind ++;
			}
		}

		reservedBlocks = 0;
		availableBlocks = blocks.length;
		assignBlocks(blocks.length, Block.MODE_DORMANT, true);

		reservedBlocks = 0;
		availableBlocks = 0;

		timeLeft = 1;
		timeLeftStart = 1;
		started = false;

		score = 0;

		

		hud.updateScore();
		introText.updateScore();

		lives = maxLives;
	}

	override public function update()
	{
		if (started)
		{
			timeLeft -= HXP.elapsed;
		}

		if (timeLeft <= 0)
		{
			lose();
		}

		if (resetting) 
		{
			HXP.screen.color = HXP.colorLerp(oldBgColour, bgColour, transition);
		}
		

		super.update();

		if (Input.pressed(Key.M))
		{
			muted = !muted;
			Sfx.setVolume("sound", muted ? 0 : 1);
			Data.write("muted", muted);
			Data.save("save");

			if (muted)
			{
				music.stop();
			}
			else
			{
				music.play(0.8);
			}
		}
	}

	private function tweenComplete(e:Dynamic)
	{
		HXP.screen.color = bgColour;
		resetting = false;
	}

	public function newMode()
	{
		addBlock();

		gameState = states[Math.floor(Math.random() * states.length)];
		chooseColour();
		//Tell entities they need to record current positions/colours
		var transitionEntities:Array<entities.TransitionEntity> = [];
		getClass(entities.TransitionEntity, transitionEntities);

		for(e in transitionEntities)
		{
			e.setupTransition();
		}

		reservedBlocks = 0;
		assignBlocks(availableBlocks, Block.MODE_IDLE, true);
		reservedBlocks = 0;

		//redo colour for dormant blocks
		for(i in availableBlocks...blocks.length)
		{
			blocks[i].setMode(Block.MODE_DORMANT);
		}

		hud.newValues();
		introText.newValues();

		gameState.init();
		gameState.setGoalPosition(goal);
		gameState.setPlayerPosition(player);
		timeLeftStart = gameState.time(this);
		timeLeft = timeLeftStart;
		
		started = true;
		resetting = true;
		transition = 0;
		
		stateTween.tween(this, "transition", 1, 1, Ease.expoOut);
		stateTween.start();
	}

	public function addBlock()
	{
		if (availableBlocks < blocks.length)
		{
			availableBlocks += 1;
		}
	}

	public function win()
	{
		winSound.play(0.5);
		if (lives < maxLives)
		{
			lives += 1;
			//hud.updateLives(lives);
		}

		score += cast timeLeft * 10;
		if (score > highScore)
		{
			highScore = score;
		}

		hud.updateScore();
		introText.updateScore();

		newMode();
	}

	public function lose()
	{
		
		if (lives > 0)
		{
			HXP.screen.shake(3, 0.2);
			loseSound.play(0.7);
			lives -= 1;
			newMode();
			//hud.updateLives(lives);
		}
		else
		{
			HXP.screen.shake(4, 0.5);
			finalSound.play(0.7);
			var transitionEntities:Array<entities.TransitionEntity> = [];
			getClass(entities.TransitionEntity, transitionEntities);

			for(e in transitionEntities)
			{
				e.setupTransition();
			}

			lastScore = score;
			score = 0;

			Data.write("highScore", highScore);
			Data.write("lastScore", lastScore);
			Data.save("save");

			hud.updateScore();
			introText.updateScore();

			init();

			resetting = true;
			transition = 0;
			stateTween.start();
		}
	}

	public function assignBlocks(num:Int, mode:Int, unsplit:Bool = false):Array<Block>
	{
		var ret:Array<Block> = [];
		for(i in reservedBlocks...cast Math.min(reservedBlocks + num, availableBlocks))
		{
			if (unsplit)
			{
				blocks[i].unSpilt();
			}
			blocks[i].setMode(mode);
			ret.push(blocks[i]);
		}

		reservedBlocks += num;

		return ret;
	}

	//http://flash-anni.blogspot.co.nz/2013/07/shuffle-array-in-haxe-nme.html
	public static function shuffleBlockArray(array:Array<Block>):Array<Block>
	{
		var len:Int = array.length;
		var ret:Array<Block> = array.slice(0, len);
		var el:Block;
		var rn:Int;

		for(i in 0...len)
		{
			el = ret[i];
			rn = Math.floor(Math.random() * len);
			ret[i] = ret[rn];
			ret[rn] = el;
		}

		return ret;
	}

	public function chooseColour()
	{
		var i = Math.floor(Math.random() * colours.length);
		var colourArray = colours[i];
		oldBgColour = bgColour;

		bgColour = colourArray[0];
		wallColour = colourArray[1];
		deathColour = colourArray[2];
		specialColour = colourArray[3];
	}
}