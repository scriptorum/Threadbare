package game.handler; 

import com.haxepunk.utils.Key;
import flaxen.component.Image;
import flaxen.component.Offset;
import flaxen.component.Position;
import flaxen.core.Flaxen;
import flaxen.core.FlaxenHandler;
import flaxen.core.Log;
import flaxen.service.InputService;

class PlayHandler extends FlaxenHandler
{
	public var f:Flaxen;

	public function new(f:Flaxen)
	{
		super();
		this.f = f;
	}

	override public function start(_)
	{
		f.newEntity().add(new Image("art/inscrutablegames.png")).add(Offset.center()).add(Position.center());
	}

	override public function update(_)
	{
		var key = InputService.lastKey();

		#if debug
		if(key == Key.D)
		{
			trace("Dumping log(s)");
			flaxen.util.LogUtil.dumpLog(f, Sys.getCwd() + "entities.txt");
			for(setName in f.getComponentSetKeys())
				trace(setName + ":{" + f.getComponentSet(setName) + "}");
		}
		#end

		InputService.clearLastKey();
	}
}
