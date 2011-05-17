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
	 * <span lang="ja">Version クラスは、バージョン情報を保持し、バージョンの比較などを行うためのモデルクラスです。</span>
	 * <span lang="en">Version class is a model class to store the version information and compare the version.</span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class Version {
		
		/**
		 * バージョン情報のフォーマットを判別する正規表現を取得します。
		 */
		private static const _FORMAT_REGEXP:String = "^([0-9]+)(\.[0-9]+)?(\.[0-9]+)?( .*$)?";
		
		/**
		 * バージョン情報を切り分ける正規表現を取得します。
		 */
		private static const _SPLIT_REGEXP:String = "^([0-9]+)([^0-9]([0-9]*))?([^0-9]([0-9]*))?.*$";
		
		
		
		
		
		/**
		 * <span lang="ja">メジャーバージョンを取得します。</span>
		 * <span lang="en">Get the major version.</span>
		 */
		public function get majorVersion():int { return _majorVersion; }
		private var _majorVersion:int = 0;
		
		/**
		 * <span lang="ja">マイナーバージョンを取得します。</span>
		 * <span lang="en">Get the minor version.</span>
		 */
		public function get minorVersion():int { return _minorVersion; }
		private var _minorVersion:int = 0;
		
		/**
		 * <span lang="ja">ビルドバージョンを取得します。</span>
		 * <span lang="en">Get the build version.</span>
		 */
		public function get buildVersion():int { return _buildVersion; }
		private var _buildVersion:int = 0;
		
		/**
		 * <span lang="ja">リリース情報を取得します。</span>
		 * <span lang="en">Get the release information.</span>
		 */
		public function get release():String { return _release; }
		private var _release:String;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい Version インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Version object.</span>
		 * 
		 * @param majorVersionOrVersionValue
		 * <span lang="ja">メジャーバージョン、またはバージョンを表すストリング値です。</span>
		 * <span lang="en">The major version or the string value to express the version.</span>
		 * @param minorVersion
		 * <span lang="ja">マイナーバージョンです。</span>
		 * <span lang="en">The minor version.</span>
		 * @param buildVersion
		 * <span lang="ja">ビルドバージョンです。</span>
		 * <span lang="en">The build version.</span>
		 * @param release
		 * <span lang="ja">リリース情報です。</span>
		 * <span lang="en">The release information.</span>
		 */
		public function Version( majorVersionOrVersionValue:*, minorVersion:int = 0, buildVersion:int = 0, release:String = null ) {
			switch ( true ) {
				case majorVersionOrVersionValue is XML		:
				case majorVersionOrVersionValue is XMLList	:
				case majorVersionOrVersionValue is String	: {
					majorVersionOrVersionValue = String( majorVersionOrVersionValue );
					
					// フォーマットを確認する
					if ( !new RegExp( _FORMAT_REGEXP ).test( majorVersionOrVersionValue ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_005 ).toString( "majorVersionOrVersionValue" ) ); }
					
					// 引数を設定する
					var items:Array = String( majorVersionOrVersionValue ).split( " " );
					
					var versions:Array = new RegExp( _SPLIT_REGEXP ).exec( items.shift() );
					if ( !versions ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_005 ).toString( "version" ) ); }
					
					_majorVersion = parseInt( versions[1] );
					_minorVersion = parseInt( versions[3] );
					_buildVersion = parseInt( versions[5] );
					
					_release = String( items.join( " " ) );
					break;
				}
				case majorVersionOrVersionValue is Number	: {
					// 引数を設定する
					_majorVersion = Math.floor( majorVersionOrVersionValue );
					_minorVersion = minorVersion;
					_buildVersion = buildVersion;
					_release = release || "";
					break;
				}
				default										: { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_005 ).toString( "majorVersionOrVersionValue" ) ); }
			}
		}
		
		
		
		
		
		/**
		 * <span lang="ja">対象の Version インスタンスを比較した結果を返します。
		 * この比較結果にリリース情報の値は影響しません。</span>
		 * <span lang="en">Returns the result of comparison of the Version instance.
		 * The result of comparison do not affect to the value of release information.</span>
		 * 
		 * @param version
		 * <span lang="ja">比較したい Version インスタンスです。</span>
		 * <span lang="en">The Version instance to compare.</span>
		 * @return
		 * <span lang="ja">自身のバージョンが高ければ 1 以上の数値を、バージョンが同じであれば 0 を、バージョンが低ければ -1 以下の数値です。</span>
		 * <span lang="en"></span>
		 */
		public function compare( version:Version ):int {
			// メジャーバージョンが高ければ 3 を返す
			if ( _majorVersion > version._majorVersion ) { return 3; }
			
			// メジャーバージョンが低ければ -3 を返す
			if ( _majorVersion < version._majorVersion ) { return -3; }
			
			// マイナーバージョンが高ければ 2 を返す
			if ( _minorVersion > version._minorVersion ) { return 2; }
			
			// マイナーバージョンが低ければ -2 を返す
			if ( _minorVersion < version._minorVersion ) { return -2; }
			
			// ビルドバージョンが高ければ 1 を返す
			if ( _buildVersion > version._buildVersion ) { return 1; }
			
			// ビルドバージョンが低ければ -1 を返す
			if ( _buildVersion < version._buildVersion ) { return -1; }
			
			return 0;
		}
		
		/**
		 * <span lang="ja">2 つのバージョンをリリース情報も含めて完全に一致するかどうかを比較した結果を返します。</span>
		 * <span lang="en">Returns the value above 1 if the own version is higher, returns 0 if the version is same and return the value below -1 if the own version is lower.</span>
		 * 
		 * @param version
		 * <span lang="ja">比較したい Version インスタンスです。</span>
		 * <span lang="en">The Version instance to compare.</span>
		 * @return
		 * <span lang="ja">完全に一致する場合には true を、一致しない場合には false です。</span>
		 * <span lang="en">Returns true if completly same, otherwise return false.</span>
		 */
		public function equals( version:Version ):Boolean {
			return ( toString() == version.toString() );
		}
		
		/**
		 * <span lang="ja">Version インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an Version subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい Version インスタンスです。</span>
		 * <span lang="en">A new Version object that is identical to the original.</span>
		 */
		public function clone():Version {
			return new Version( _majorVersion, _minorVersion, _buildVersion, _release );
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @param format
		 * <span lang="ja">取得したいバージョンストリングを構成するフォーマットです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		public function toString( format:String = null ):String {
			format ||= "M.m.b r";
			
			format = format.replace( new RegExp( "M", "g" ), _majorVersion );
			format = format.replace( new RegExp( "m", "g" ), _minorVersion );
			format = format.replace( new RegExp( "b", "g" ), _buildVersion );
			format = format.replace( new RegExp( "r", "g" ), _release );
			
			return format;
		}
	}
}
