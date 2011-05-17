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
package jp.nium.external {
	import adobe.utils.MMExecute;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ArrayUtil;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.ObjectUtil;
	import jp.nium.utils.StringUtil;
	
	/**
	 * <span lang="ja">COREX クラスは、SWF ファイルを再生中の Flash オーサリングツールと、COREX アプリケーションとの通信機能を提供するクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class COREX {
		
		/**
		 * @private
		 */
		public function COREX() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">COREX を起動します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param bootClassPath
		 * <span lang="ja">起動時に基点となるクラスパスです。</span>
		 * <span lang="en"></span>
		 * @param bootClassArgs
		 * <span lang="ja">基点となるクラスのコンストラクタ引数です。</span>
		 * <span lang="en"></span>
		 * @param libraryPaths
		 * <span lang="ja">クラスライブラリパスを含む配列です。</span>
		 * <span lang="en"></span>
		 * @param param
		 * <span lang="en">COREX の起動引数が設定されたオブジェクトです。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function boot( bootClassPath:String, bootClassArgs:Array = null, libraryPaths:Array = null, param:Object = null ):void {
			// 無効化されていれば終了する例外をスローする
			if ( !JSFL.enabled ) { return; }
			
			bootClassArgs ||= [];
			libraryPaths ||= [];
			param ||= {};
			
			var bootClassArgsString:String = ArrayUtil.toString( bootClassArgs );
			var libraryPathsString:String = ArrayUtil.toString( libraryPaths );
			var paramString:String = ObjectUtil.toString( param );
			
			bootClassArgsString = StringUtil.collectBreak( bootClassArgsString, "" );
			bootClassArgsString = StringUtil.collectBreak( bootClassArgsString, "" );
			bootClassArgsString = StringUtil.collectBreak( bootClassArgsString, "" );
			
			MMExecute( '$={u:fl.configURI+"COREX.jsfl",$:function(){alert(String.fromCharCode(67,79,82,69,88,32,105,115,32,110,111,116,32,105,110,115,116,97,108,108,101,100,46))}};(eval(FLfile.read($.u))||$).$( "' + bootClassPath + '", ' + bootClassArgsString + ', ' + libraryPathsString + ', ' + paramString + ' );' );
		}
	}
}
