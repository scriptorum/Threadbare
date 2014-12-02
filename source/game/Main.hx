package game; 

import flaxen.core.Flaxen;
import flaxen.core.FlaxenOptions;
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
