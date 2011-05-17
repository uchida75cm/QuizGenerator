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
    /**
     *  define SWFSize state.
     */
    public class SWFSizeState
    {
        /**
         *  unknown state.
         */
        public static const UNKNOWN:uint = 0;

        /**
         *  current size is under the minimum size.
         */
        public static const MINIMUM:uint = 1;

        /**
         *  current size is between minimum and maximum.
         */
        public static const LIQUID:uint = 2;

        /**
         *  current size is over the maximum size.
         */
        public static const MAXIMUM:uint = 3;
    }
}
