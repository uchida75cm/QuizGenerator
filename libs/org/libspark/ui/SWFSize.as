/**
 * SWFSize - fix stage size dynamically.
 *
 * Copyright (c) 2008 - 2010 Spark project (www.libspark.org)
 *
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 */
package org.libspark.ui
{
    import flash.errors.IllegalOperationError;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.external.ExternalInterface;

    /**
     *  fix swf size.
     */
    public class SWFSize extends EventDispatcher
    {
        /**
         *  external javascript function.
         */
        public static const EXTERNAL_FUNCTION:String = "function(id,minW,minH,maxW,maxH){var STATE_UNKNOWN=0,STATE_MIN=1,STATE_LIQUID=2,STATE_MAX=3;var win=window,doc=document,state=STATE_UNKNOWN,el,__load__,__resize__,__unload__;el=(function(){var r=doc.getElementById(id);if(!r){var nodes=doc.getElementsByTagName('embed'),len=nodes.length;for(var i=0;i<len;i++){r=nodes[i];if(r.name==id)break;}}return r;})();__load__=function(){__resize__.apply(null,arguments);};__resize__=function(){var s=STATE_UNKNOWN,w=doc.body.offsetWidth,h=doc.body.offsetHeight;if(w<minW||h<minH)s=STATE_MIN;else if(w>maxW&&h>maxH)s=STATE_MAX;else s=STATE_LIQUID;w=w<minW?minW+'px':(w>maxW?maxW+'px':'100%');h=h<minH?minH+'px':(h>maxH?maxH+'px':'100%');el.style.width=w;el.style.height=h;if(doc.all)doc.body.scroll=s<STATE_LIQUID?'auto':'no';if(s!=state)el.changeState(s);state=s;};if(doc.all){__unload__=function(){win.detachEvent('onload',__load__);win.detachEvent('onresize',__resize__);win.detachEvent('onunload',__unload__);};win.attachEvent('onresize',__resize__);win.attachEvent('onunload',__unload__);if(!doc.body){win.attachEvent('onload',__load__);}else{__load__();}}else{__unload__=function(){win.removeEventListener('resize',__resize__,false);win.removeEventListener('unload',__unload__,false);doc.removeEventListener('onload',__load__,false);};win.addEventListener('resize',__resize__,false);win.addEventListener('unload',__unload__,false);if(!doc.body){doc.addEventListener('onload',__load__,false);}else{__load__();}}}";

        private static var _instance:SWFSize;
        private static var _isReady:Boolean = false;
        private var _state:uint = 0;

        /**
         *  initialize the object.
         *
         *  @param  minWidth        minimum stage width.
         *  @param  minHeight       minimum stage height.
         *  @param  maxWidth        maximum stage width.
         *  @param  maxHeight       maximum stage height.
         */
        public static function initialize(minWidth:Number, minHeight:Number, maxWidth:Number=NaN,
                                          maxHeight:Number=NaN):void
        {
            if (!available || isReady) return;

            //  mark as already loaded.
            _isReady = true;

            //  if do not specified maximum width and maximum width, set infinity automatically.
            maxWidth ||= Infinity;
            maxHeight ||= Infinity;

            //  execute main process.
            instance.execute(ExternalInterface.objectID, minWidth, minHeight,
                             maxWidth, maxHeight);
        }

        /**
         *  @inheritDoc
         */
        public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false,
                                                priority:int=0, useWeakReference:Boolean=false):void
        {
            instance.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        /**
         *  @inheritDoc
         */
        public static function dispatchEvent(event:Event):Boolean
        {
            return instance.dispatchEvent(event);
        }

        /**
         *  @inheritDoc
         */
        public static function hasEventListener(type:String):Boolean
        {
            return instance.hasEventListener(type);
        }

        /**
         *  @inheritDoc
         */
        public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
        {
            instance.removeEventListener(type, listener, useCapture);
        }

        /**
         *  @inheritDoc
         */
        public static function willTrigger(type:String):Boolean
        {
            return instance.willTrigger(type);
        }

        /**
         *  get SWFSize instance.
         *
         *  @return     SWFSize instance.
         */
        public static function get instance():SWFSize
        {
            if (!_instance)
            {
                _instance = new SWFSize(new SWFSizeConfigure());
            }
            return _instance;
        }

        /**
         *  checking SWFSize is ready.
         *
         *  @return bool
         */
        public static function get isReady():Boolean
        {
            return _isReady;
        }

        /**
         *  checking SWFSize is available.
         *
         *  @return bool
         */
        public static function get available():Boolean
        {
            var f:Boolean = false;

            if (!ExternalInterface.available) return f;

            try
            {
                f = Boolean(ExternalInterface.call("function(){return true;}"));
            }
            catch (e:Error)
            {
                trace("Warning: turn off SWFSize because can't access external interface.");
            }
            return f;
        }

        /**
         *  get current state.
         */
        public static function get state():uint
        {
            return instance.state;
        }

        /**
         *  constructor.
         *
         *  @private
         */
        public function SWFSize(configure:SWFSizeConfigure)
        {
            if (!configure)
            {
                throw new IllegalOperationError("SWFSize can't instantiate directly.");
            }
        }

        /**
         *  get current state.
         *
         *  @return int         current state.
         */
        public function get state():uint
        {
            return _state;
        }

        /**
         *  execute external process.
         *
         *  @param  id              target object id.
         *  @param  minWidth        minimum stage width.
         *  @param  minHeight       minimum stage height.
         *  @param  maxWidth        maximum stage width.
         *  @param  maxHeight       maximum stage height.
         */
        private function execute(id:String, minWidth:Number, minHeight:Number,
                                 maxWidth:Number, maxHeight:Number):void
        {
            //  set external callback.
            ExternalInterface.addCallback('changeState', changeState);
            //  execute external function.
            ExternalInterface.call(EXTERNAL_FUNCTION, id, minWidth, minHeight,
                                   maxWidth, maxHeight);
        }

        /**
         *  change current state.
         *  will execute when size state changed.
         *
         *  @param uint         new state.
         */
        private function changeState(state:uint):void
        {
            _state = state;

            dispatchEvent(new SWFSizeEvent(SWFSizeEvent.CHANGE, false, false, state));
        }
    }
}

//  internal uses.
internal class SWFSizeConfigure {}
