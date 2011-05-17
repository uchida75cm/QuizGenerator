/**
 * jp.nium Classes
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://classes.nium.jp/
 * 
 * jp.nium Classes is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package jp.nium.utils {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	
	/**
	 * <span lang="ja">MathUtil クラスは、算術演算のためのユーティリティクラスです。</span>
	 * <span lang="en">The MathUtil class is an utility class for arithmetic operation.</span>
	 */
	public final class MathUtil {
		
		/**
		 * @private
		 */
		public function MathUtil() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">数値を指定された周期内に収めて返します。</span>
		 * <span lang="en">Returns the value of number put in the specified cycle.</span>
		 * 
		 * @param number
		 * <span lang="ja">周期内に収めたい数値です。</span>
		 * <span lang="en">The value which want to put in the cycle.</span>
		 * @param cycle
		 * <span lang="ja">周期となる数値です。</span>
		 * <span lang="en">The cycle value.</span>
		 * @return
		 * <span lang="ja">変換後の数値です。</span>
		 * <span lang="en">The translated value.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function cycle( number:Number, cycle:Number ):Number {
			return ( number % cycle + cycle ) % cycle;
		}
		
		/**
		 * <span lang="ja">範囲内に適合する値を返します。</span>
		 * <span lang="en">Returns the value suited within the range.</span>
		 * 
		 * @param number
		 * <span lang="ja">範囲内に適合させたい数値です。</span>
		 * <span lang="en">The number which wanted to suit within the range.</span>
		 * @param min
		 * <span lang="ja">範囲の最小値となる数値です。</span>
		 * <span lang="en">The mininum value of the range.</span>
		 * @param max
		 * <span lang="ja">範囲の最大値となる数値です。</span>
		 * <span lang="en">The maximum value of the range.</span>
		 * @return
		 * <span lang="ja">変換後の数値です。</span>
		 * <span lang="en">The translated value.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function range( number:Number, min:Number, max:Number ):Number {
			// min の方が max よりも大きい場合に入れ替える
			if ( min > max ) {
				var tmp:Number = min;
				min = max;
				max = tmp;
			}
			
			return Math.max( min, Math.min( number, max ) );
		}
		
		/**
		 * <span lang="ja">分母が 0 の場合に 0 となるパーセント値を返します。</span>
		 * <span lang="en">Returns the percent value (return 0 if the denominator is 0).</span>
		 * 
		 * @param numerator
		 * <span lang="ja">分子となる数値です。</span>
		 * <span lang="en">The numerator value.</span>
		 * @param denominator
		 * <span lang="ja">分母となる数値です。</span>
		 * <span lang="en">The denominator value.</span>
		 * @return
		 * <span lang="ja">変換後の数値です。</span>
		 * <span lang="en">The translated value.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function percent( numerator:Number, denominator:Number ):Number {
			if ( denominator == 0) { return 0; }
			return numerator / denominator * 100;
		}
		
		/**
		 * <span lang="ja">数値が偶数かどうかを返します。</span>
		 * <span lang="en">Returns if the value is even number.</span>
		 * 
		 * @param number
		 * <span lang="ja">テストしたい数値です。</span>
		 * <span lang="en">The number to test.</span>
		 * @return
		 * <span lang="ja">偶数であれば true を、奇数であれば false を返します。</span>
		 * <span lang="en">Returns true if the value is even number, otherwise return false.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function even( number:Number ):Boolean {
			var h:Number = number / 2;
			return h == Math.ceil( h );
		}
	}
}
