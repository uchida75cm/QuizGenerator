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
    import flash.events.Event;

    /**
     *
     */
    public class SWFSizeEvent extends Event
    {
        public static const CHANGE:String = "change";

        private var _state:uint;

        /**
         *  constructor.
         */
        public function SWFSizeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, state:uint=0)
        {
            super(type, bubbles, cancelable);

            _state = state;
        }

        /**
         *  get current state.
         */
        public function get state():uint
        {
            return _state;
        }

        /**
         *  @inheritDoc.
         */
        override public function clone():Event
        {
            return new SWFSizeEvent(type, bubbles, cancelable, state);
        }

        /**
         *  @inheritDoc.
         */
        override public function toString():String
        {
            return formatToString('SWFSizeEvent', 'type', 'bubbles', 'cancelable', 'state');
        }
    }
}
