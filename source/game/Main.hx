package game; 

import flaxen.Flaxen;
import flaxen.FlaxenOptions;
import game.handler.PlayHandler;

class Main extends Flaxen
{
	public static function main()
	{
		new Main(600, 600, 60, true);
	}

	override public function ready()
	{
		setHandler(new PlayHandler(this));
	}
}
