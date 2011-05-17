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
	import jp.nium.utils.StringUtil;
	
	/**
	 * <span lang="ja">JSFL クラスは、SWF ファイルを再生中の Flash オーサリングツールと、JSFL を使用して通信を行うクラスです。</span>
	 * <span lang="en">The JSFL class communicates with the Flash authoring tool which are playing the SWF file, using JSFL.</span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class JSFL {
		
		/**
		 * <span lang="ja">Flash オーサリングツールとの JSFL 通信が可能かどうかを取得します。</span>
		 * <span lang="en">Returns if it is able to communicate with Flash authoring tool via JSFL.</span>
		 */
		public static function get enabled():Boolean { return _enabled; }
		private static var _enabled:Boolean = false;
		
		/**
		 * <span lang="ja">Flash オーサリングツールが実行されている OS 情報を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get platform():String { return _platform; }
		private static var _platform:String = "";
		
		/**
		 * <span lang="ja">Flash オーサリングツールが実行されている環境の言語情報を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get language():String { return _platform; }
		private static var _language:String = "";
		
		/**
		 * <span lang="ja">Flash オーサリングツールのメジャーバージョンを取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get majorVersion():int { return _majorVersion; }
		private static var _majorVersion:int;
		
		/**
		 * <span lang="ja">Flash オーサリングツールのマイナーバージョンを取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get minorVersion():int { return _minorVersion; }
		private static var _minorVersion:int;
		
		/**
		 * <span lang="ja">Flash オーサリングツールのリビジョンバージョンを取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get revisionVersion():int { return _revisionVersion; }
		private static var _revisionVersion:int;
		
		/**
		 * <span lang="ja">Flash オーサリングツールのビルドバージョンを取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get buildVersion():int { return _buildVersion; }
		private static var _buildVersion:int;
		
		/**
		 * <span lang="ja">ローカルユーザーの "Configuration" ディレクトリを file:/// URI として表す完全パスを指定するストリングを取得します。</span>
		 * <span lang="en">a string that specifies the full path for the local user's Configuration directory as a file:/// URI.</span>
		 */
		public static function get configURI():String { return _configURI; }
		private static var _configURI:String = "";
		
		
		
		
		
		/**
		 * 初期化する
		 */
		( function():void {
			try {
				_configURI = MMExecute( '( function() { return fl.configURI; } )()' ) || "";
			}
			catch ( err:Error ) {}
			
			// MMExecute の引数が存在しなければ終了する
			if ( !_configURI ) { return; }
			
			// 有効化する
			_enabled = true;
			
			// Flash オーサリングツールの情報を取得する
			var flversion:String = MMExecute( '( function() { return fl.version; } )()' );
			
			var flversions:Array = flversion.split( " " );
			_platform = flversions[0];
			
			var versions:Array = String( flversions[1] ).split( "," );
			_majorVersion = parseInt( versions[0] );
			_minorVersion = parseInt( versions[1] );
			_buildVersion = parseInt( versions[2] );
			_revisionVersion = parseInt( versions[3] );
			
			_language = _configURI.split( "/" ).slice( -3, -2 ).join( "/" );
		} )();
		
		
		
		
		
		/**
		 * @private
		 */
		public function JSFL() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">Flash JavaScript アプリケーションプログラミングインターフェイスを経由して、関数を実行します。</span>
		 * <span lang="en">Execute function via Flash JavaScript Application Programming Interface.</span>
		 * 
		 * @param funcName
		 * <span lang="ja">実行したい関数名です。</span>
		 * <span lang="en">The name of the function to execute.</span>
		 * @param args
		 * <span lang="en">funcName に渡すパラメータです。</span>
		 * <span lang="en">The parameter to pass to funcName.</span>
		 * @return
		 * <span lang="en">funcName を指定した場合に、関数の結果をストリングで返します。</span>
		 * <span lang="en">Return the result of the function as string if funcName specified.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function call( funcName:String, ... args:Array ):* {
			// 無効化されていれば終了する例外をスローする
			if ( !_enabled ) { return; }
			
			// 引数を String に変換する
			var argString:String = ArrayUtil.toString( args );
			argString = StringUtil.collectBreak( argString, "\\n" );
			
			// 実行する
			return StringUtil.toProperType( MMExecute( "( function() { return eval( decodeURI( \"( " + encodeURI( funcName ) + " ).apply( null, " + encodeURI( argString ) + " );\" ) ); } )()" ) );
		}
		
		/**
		 * <span lang="ja">JavaScript ファイルを実行します。関数をパラメータの 1 つとして指定している場合は、その関数が実行されます。また関数内にないスクリプトのコードも実行されます。スクリプト内の他のコードは、関数の実行前に実行されます。</span>
		 * <span lang="en">executes a JavaScript file. If a function is specified as one of the arguments, it runs the function and also any code in the script that is not within the function. The rest of the code in the script runs before the function is run.</span>
		 * 
		 * @param fileURL
		 * <span lang="ja">実行するスクリプトファイルの名前を指定した file:/// URI で表されるストリングです。</span>
		 * <span lang="en">string, expressed as a file:/// URI, that specifies the name of the script file to execute.</span>
		 * @param funcName
		 * <span lang="en">fileURI で指定した JSFL ファイルで実行する関数を識別するストリングです。</span>
		 * <span lang="en">A string that identifies a function to execute in the JSFL file that is specified in fileURI. This parameter is optional.</span>
		 * @param args
		 * <span lang="en">funcName に渡す省略可能なパラメータです。</span>
		 * <span lang="en">optional parameter that specifies one or more arguments to be passed to funcname.</span>
		 * @return
		 * <span lang="en">funcName を指定すると、関数の結果をストリングで返します。指定しない場合は、何も返されません。</span>
		 * <span lang="en">The function's result as a string, if funcName is specified; otherwise, nothing.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function runScript( fileURL:String, funcName:String = null, ... args:Array ):* {
			return call.apply( null, [ "fl.runScript", fileURL, funcName || "" ].concat( args ) );
		}
		
		
		/**
		 * <span lang="ja">テキストストリングを [出力] パネルに送ります。</span>
		 * <span lang="en">Sends a text string to the Output panel.</span>
		 * 
		 * @param messages
		 * <span lang="ja">[出力] パネルに表示するストリングです。</span>
		 * <span lang="en">string that appears in the Output panel.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function fltrace( ... messages:Array ):void {
			var message:String = StringUtil.collectBreak( messages.join( " " ), "\\n" );
			
			if ( _enabled ) {
				call( "fl.trace", message );
			}
			else {
				Logger.info( "JSFL.fltrace(", message, ")" );
			}
		}
		
		/**
		 * <span lang="ja">モーダル警告ダイアログボックスに、ストリングおよび [OK] ボタンを表示します。</span>
		 * <span lang="en">displays a string in a modal Alert dialog box, along with an OK button.</span>
		 * 
		 * @param messages
		 * <span lang="ja">警告ダイアログボックスに表示するメッセージを指定するストリングです。</span>
		 * <span lang="en">A string that specifies the message you want to display in the Alert dialog box.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function alert( ... messages:Array ):void {
			var message:String = StringUtil.collectBreak( messages.join( " " ), "\\n" );
			
			if ( _enabled ) {
				call( "alert", message );
			}
			else {
				Logger.info( "JSFL.alert(", message, ")" );
			}
		}
		
		/**
		 * <span lang="ja">モーダル警告ダイアログボックスに、ストリングおよび [OK] ボタンと [キャンセル] ボタンを表示します。</span>
		 * <span lang="en">displays a string in a modal Alert dialog box, along with OK and Cancel buttons.</span>
		 * 
		 * @param messages
		 * <span lang="ja">警告ダイアログボックスに表示するメッセージを指定するストリングです。</span>
		 * <span lang="en">A string that specifies the message you want to display in the Alert dialog box.</span>
		 * @return
		 * <span lang="ja">ユーザーが [OK] をクリックしたときは true、[キャンセル] をクリックしたときは false を返します。</span>
		 * <span lang="en">true if the user clicks OK; false if the user clicks Cancel.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function confirm( ... messages:Array ):Boolean {
			var message:String = StringUtil.collectBreak( messages.join( " " ), "\\n" );
			
			if ( _enabled ) { return Boolean( !!StringUtil.toProperType( call( "confirm", message ) ) ); }
			
			Logger.info( "JSFL.confirm(", message, ")" );
			
			return false;
		}
		
		/**
		 * <span lang="ja">モーダル警告ダイアログボックスに、プロンプトとオプションのテキストおよび [OK] ボタンと [キャンセル] ボタンを表示します。</span>
		 * <span lang="en">displays a prompt and optional text in a modal Alert dialog box, along with OK and Cancel buttons.</span>
		 * 
		 * @param title
		 * <span lang="ja">プロンプトダイアログボックスに表示するストリングです。</span>
		 * <span lang="en">A string to display in the Prompt dialog box.</span>
		 * @param messages
		 * <span lang="ja">プロンプトダイアログボックスに表示するストリングです。</span>
		 * <span lang="en">An optional string to display as a default value for the text field.</span>
		 * @return
		 * <span lang="ja">ユーザーが [OK] をクリックした場合はユーザーが入力したストリング、[キャンセル] をクリックした場合は null を返します。</span>
		 * <span lang="en">The string the user typed if the user clicks OK; null if the user clicks Cancel.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function prompt( title:String, ... messages:Array ):String {
			var message:String = StringUtil.collectBreak( messages.join( " " ), "\\n" );
			
			if ( _enabled ) {
				return call( "prompt", title, message );
			}
			else {
				Logger.info( "JSFL.prompt(", title, ",", message, ")" );
			}
			
			return null;
		}
		
		/**
		 * <span lang="ja">ファイルを開く、またはファイルを保存システムダイアログボックスを開き、ユーザーは開いたり保存したりするファイルを指定できます。</span>
		 * <span lang="en">Opens a File Open or File Save system dialog box and lets the user specify a file to be opened or saved.</span>
		 * 
		 * @param browseType
		 * <span lang="ja">ファイルの参照操作の種類を指定するストリングです。</span>
		 * <span lang="en">A string that specifies the type of file browse operation.</span>
		 * @param title
		 * <span lang="ja">ファイルを開くダイアログボックスまたはファイルを保存ダイアログボックスのタイトルを指定するストリングです。</span>
		 * <span lang="en">A string that specifies the title for the File Open or File Save dialog box.</span>
		 * @return
		 * <span lang="en">file:/// URI で表したファイルの URL です。</span>
		 * <span lang="en">The URL of the file, expressed as a file:/// URI.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function browseForFileURL( browseType:String, title:String = null ):String {
			if ( _enabled ) {
				return call( "fl.browseForFileURL", browseType, title );
			}
			else {
				Logger.info( "JSFL.browseForFileURL(", browseType, ",", title, ")" );
			}
			
			return null;
		}
		
		/**
		 * <span lang="ja">フォルダを参照ダイアログボックスを表示し、ユーザーがフォルダを選択できるようにします。</span>
		 * <span lang="en">Displays a Browse for Folder dialog box and lets the user select a folder.</span>
		 * 
		 * @param description
		 * <span lang="ja">フォルダを参照ダイアログボックスの説明を指定する省略可能なストリングです。</span>
		 * <span lang="en">An optional string that specifies the description of the Browse For Folder dialog box.</span>
		 * @return
		 * <span lang="en">file:/// URI で表したフォルダの URL です。</span>
		 * <span lang="en">The URL of the folder, expressed as a file:/// URI.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function browseForFolderURL( description:String = null ):String {
			if ( _enabled ) {
				return call( "fl.browseForFolderURL", description );
			}
			else {
				Logger.info( "JSFL.browseForFolderURL(", description, ")" );
			}
			
			return null;
		}
	}
}
