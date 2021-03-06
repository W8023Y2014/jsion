/*
 Copyright aswing.org, see the LICENCE.txt.
*/
package jsion.ui.graphics{

	import flash.display.Graphics;	
	
	import jsion.*;
	
	/**
	 * Pen to draw lines.<br>
	 * Use it with a org.aswing.graphics.Graphics2D instance
	 * @author n0rthwood
	 */	
	public interface IPen extends IDispose
	{

		/**
		 *
		 * This method will be called by Graphics2D autumaticlly.<br>
		 * It will set the lineStyle to the instance of flash.display.Graphics
		 * @param target the instance of graphics from a display object
		 */ 
		function setTo(target:Graphics):void;
	}

}

