package game.handler; 

import com.haxepunk.utils.Key;
import flaxen.component.Image;
import flaxen.component.Offset;
import flaxen.component.Size;
import flaxen.component.Position;
import flaxen.Flaxen;
import flaxen.FlaxenHandler;
import flaxen.Log;
import flaxen.util.LogUtil;
import flaxen.service.InputService;

class PlayHandler extends FlaxenHandler
{
	override public function start()
	{
		var e = f.newEntity()
			.add(new Image("art/dot.png"))
			.add(new Size(50, 50))
			.add(Offset.center())
			.add(Position.center());
		trace("Threadbare ready!");
	}

	override public function update()
	{
		var key = InputService.lastKey();

		#if debug
		if(key == Key.D)
		{
			trace("Entities:");
			trace(LogUtil.dumpEntities(f));
			
			trace("Component Sets:");
			for(setName in f.getComponentSetKeys())
				trace(setName + ":{" + f.getComponentSet(setName) + "}");
		}
		#end

		InputService.clearLastKey();
	}
}
