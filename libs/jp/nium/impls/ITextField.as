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
package jp.nium.impls {
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	/**
	 * <span lang="ja">ITextField インターフェイスは、対象に対して TextField として必要となる機能を実装します。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public interface ITextField extends IInteractiveObject {
		
		/**
		 * <span lang="ja">true に設定され、テキストフィールドにフォーカスがない場合、テキストフィールド内の選択内容は灰色でハイライト表示されます。</span>
		 * <span lang="en">When set to true and the text field is not in focus, Flash Player highlights the selection in the text field in gray.</span>
		 */
		function get alwaysShowSelection():Boolean;
		function set alwaysShowSelection( value:Boolean ):void;
		
		/**
		 * <span lang="ja">このテキストフィールドに使用されるアンチエイリアス処理のタイプです。</span>
		 * <span lang="en">The type of anti-aliasing used for this text field.</span>
		 */
		function get antiAliasType():String;
		function set antiAliasType( value:String ):void;
		
		/**
		 * <span lang="ja">テキストフィールドの自動的な拡大 / 縮小および整列を制御します。</span>
		 * <span lang="en">Controls automatic sizing and alignment of text fields.</span>
		 */
		function get autoSize():String;
		function set autoSize( value:String ):void;
		
		/**
		 * <span lang="ja">テキストフィールドに背景の塗りがあるかどうかを指定します。</span>
		 * <span lang="en">Specifies whether the text field has a background fill.</span>
		 */
		function get background():Boolean;
		function set background( value:Boolean ):void;
		
		/**
		 * <span lang="ja">テキストフィールドの背景の色です。</span>
		 * <span lang="en">The color of the text field background.</span>
		 */
		function get backgroundColor():uint;
		function set backgroundColor( value:uint ):void;
		
		/**
		 * <span lang="ja">テキストフィールドに境界線があるかどうかを指定します。</span>
		 * <span lang="en">Specifies whether the text field has a border.</span>
		 */
		function get border():Boolean;
		function set border( value:Boolean ):void;
		
		/**
		 * <span lang="ja">テキストフィールドの境界線の色です。</span>
		 * <span lang="en">The color of the text field border.</span>
		 */
		function get borderColor():uint;
		function set borderColor( value:uint ):void;
		
		/**
		 * <span lang="ja">指定されたテキストフィールドの現在の表示範囲で最終行を示す整数です（1 から始まるインデックス）。</span>
		 * <span lang="en">An integer (1-based index) that indicates the bottommost line that is currently visible in the specified text field.</span>
		 */
		function get bottomScrollV():int;
		
		/**
		 * <span lang="ja">カーソル（キャレット）位置のインデックスです。</span>
		 * <span lang="en">The index of the insertion point (caret) position.</span>
		 */
		function get caretIndex():int;
		
		/**
		 * <span lang="ja">HTML テキストが含まれるテキストフィールド内の余分な空白（スペース、改行など）を削除するかどうかを指定するブール値です。</span>
		 * <span lang="en">A Boolean value that specifies whether extra white space (spaces, line breaks, and so on) in a text field with HTML text is removed.</span>
		 */
		function get condenseWhite():Boolean;
		function set condenseWhite( value:Boolean ):void;
		
		/**
		 * <span lang="ja">新しく挿入するテキスト (ユーザーが入力したテキストや replaceSelectedText() メソッドで挿入したテキストなど) に適用するフォーマットを指定します。</span>
		 * <span lang="en">Specifies the format applied to newly inserted text, such as text entered by a user or text inserted with the replaceSelectedText() method.</span>
		 */
		function get defaultTextFormat():TextFormat;
		function set defaultTextFormat( value:TextFormat ):void;
		
		/**
		 * <span lang="ja">テキストフィールドがパスワードテキストフィールドであるかどうかを指定します。</span>
		 * <span lang="en">Specifies whether the text field is a password text field.</span>
		 */
		function get displayAsPassword():Boolean;
		function set displayAsPassword( value:Boolean ):void;
		
		/**
		 * <span lang="ja">埋め込みフォントのアウトラインを使用してレンダリングするかどうかを指定します。</span>
		 * <span lang="en">Specifies whether to render by using embedded font outlines.</span>
		 */
		function get embedFonts():Boolean;
		function set embedFonts( value:Boolean ):void;
		
		/**
		 * <span lang="ja">このテキストフィールドに使用されるグリッドフィッティングのタイプです。</span>
		 * <span lang="en">The type of grid fitting used for this text field.</span>
		 */
		function get gridFitType():String;
		function set gridFitType( value:String ):void;
		
		/**
		 * <span lang="ja">テキストフィールドの内容を HTML で表します。</span>
		 * <span lang="en">Contains the HTML representation of the text field contents.</span>
		 */
		function get htmlText():String;
		function set htmlText( value:String ):void;
		
		/**
		 * <span lang="ja">テキストフィールド内の文字数です。</span>
		 * <span lang="en">The number of characters in a text field.</span>
		 */
		function get length():int;
		
		/**
		 * <span lang="ja">ユーザーが入力するときに、テキストフィールドに入力できる最大の文字数です。</span>
		 * <span lang="en">The maximum number of characters that the text field can contain, as entered by a user.</span>
		 */
		function get maxChars():int;
		function set maxChars( value:int ):void;
		
		/**
		 * <span lang="ja">scrollH の最大値です。</span>
		 * <span lang="en">The maximum value of scrollH.</span>
		 */
		function get maxScrollH():int;
		
		/**
		 * <span lang="ja">scrollV の最大値です。</span>
		 * <span lang="en">The maximum value of scrollV.</span>
		 */
		function get maxScrollV():int;
		
		/**
		 * <span lang="ja">複数行にわたるテキストフィールドで、ユーザーがテキストフィールドをクリックしてホイールを回転させると、自動的にスクロールするかどうかを示すブール値です。</span>
		 * <span lang="en">A Boolean value that indicates whether Flash Player automatically scrolls multiline text fields when the user clicks a text field and rolls the mouse wheel.</span>
		 */
		function get mouseWheelEnabled():Boolean;
		function set mouseWheelEnabled( value:Boolean ):void;
		
		/**
		 * <span lang="ja">フィールドが複数行テキストフィールドであるかどうかを示します。</span>
		 * <span lang="en">Indicates whether field is a multiline text field.</span>
		 */
		function get multiline():Boolean;
		function set multiline( value:Boolean ):void;
		
		/**
		 * <span lang="ja">複数行テキストフィールド内のテキスト行の数を定義します。</span>
		 * <span lang="en">Defines the number of text lines in a multiline text field.</span>
		 */
		function get numLines():int;
		
		/**
		 * <span lang="ja">ユーザーがテキストフィールドに入力できる文字のセットを指定します。</span>
		 * <span lang="en">Indicates the set of characters that a user can enter into the text field.</span>
		 */
		function get restrict():String;
		function set restrict( value:String ):void;
		
		/**
		 * <span lang="ja">現在の水平スクロール位置です。</span>
		 * <span lang="en">The current horizontal scrolling position.</span>
		 */
		function get scrollH():int;
		function set scrollH( value:int ):void;
		
		/**
		 * <span lang="ja">テキストフィールドのテキストの垂直位置です。</span>
		 * <span lang="en">The vertical position of text in a text field.</span>
		 */
		function get scrollV():int;
		function set scrollV( value:int ):void;
		
		/**
		 * <span lang="ja">テキストフィールドが選択可能であるかどうかを示すブール値です。</span>
		 * <span lang="en">A Boolean value that indicates whether the text field is selectable.</span>
		 */
		function get selectable():Boolean;
		function set selectable( value:Boolean ):void;
		
		/**
		 * <span lang="ja">現在の選択範囲の最初の文字を示す、0 から始まるインデックス値です。</span>
		 * <span lang="en">The zero-based character index value of the first character in the current selection.</span>
		 */
		function get selectionBeginIndex():int;
		
		/**
		 * <span lang="ja">現在の選択範囲における最後の文字を示す、0 から始まるインデックス値です。</span>
		 * <span lang="en">The zero-based character index value of the last character in the current selection.</span>
		 */
		function get selectionEndIndex():int;
		
		/**
		 * <span lang="ja">このテキストフィールド内の文字エッジのシャープネスです。</span>
		 * <span lang="en">The sharpness of the glyph edges in this text field.</span>
		 */
		function get sharpness():Number;
		function set sharpness( value:Number ):void;
		
		/**
		 * <span lang="ja">テキストフィールドにスタイルシートを関連付けます。</span>
		 * <span lang="en">Attaches a style sheet to the text field.</span>
		 */
		function get styleSheet():StyleSheet;
		function set styleSheet( value:StyleSheet ):void;
		
		/**
		 * <span lang="ja">テキストフィールド内の現在のテキストであるストリングです。</span>
		 * <span lang="en">A string that is the current text in the text field.</span>
		 */
		function get text():String;
		function set text( value:String ):void;
		
		/**
		 * <span lang="ja">テキストフィールドのテキストの色です（16 進数形式）。</span>
		 * <span lang="en">The color of the text in a text field, in hexadecimal format.</span>
		 */
		function get textColor():uint;
		function set textColor( value:uint ):void;
		
		/**
		 * <span lang="ja">テキストの高さです（ピクセル単位）。</span>
		 * <span lang="en">The height of the text in pixels.</span>
		 */
		function get textHeight():Number;
		
		/**
		 * <span lang="ja">テキストの幅です（ピクセル単位）。</span>
		 * <span lang="en">The width of the text in pixels.</span>
		 */
		function get textWidth():Number;
		
		/**
		 * <span lang="ja">このテキストフィールド内の文字エッジの太さです。</span>
		 * <span lang="en">The thickness of the glyph edges in this text field.</span>
		 */
		function get thickness():Number;
		function set thickness( value:Number ):void;
		
		/**
		 * <span lang="ja">テキストフィールドのタイプです。</span>
		 * <span lang="en">The type of the text field.</span>
		 */
		function get type():String;
		function set type( value:String ):void;
		
		/**
		 * <span lang="ja">テキストと共にテキストのフォーマットをコピー＆ペーストするかどうかを指定します。</span>
		 * <span lang="en">Specifies whether to copy and paste the text formatting along with the text.</span>
		 */
		function get useRichTextClipboard():Boolean;
		
		/**
		 * <span lang="ja">テキストフィールドのテキストを折り返すかどうかを示すブール値です。</span>
		 * <span lang="en">A Boolean value that indicates whether the text field has word wrap.</span>
		 */
		function get wordWrap():Boolean;
		function set wordWrap( value:Boolean ):void;
		
		
		
		
		
		/**
		 * <span lang="ja">newText パラメータで指定されたストリングを、テキストフィールドのテキストの最後に付加します。</span>
		 * <span lang="en">Appends the string specified by the newText parameter to the end of the text of the text field.</span>
		 * 
		 * @param newText
		 * <span lang="ja">既存のテキストに追加するストリングです。</span>
		 * <span lang="en">The string to append to the existing text.</span>
		 */
		function appendText( newText:String ):void;
		
		/**
		 * <span lang="ja">文字の境界ボックスである矩形を返します。</span>
		 * <span lang="en">Returns a rectangle that is the bounding box of the character.</span>
		 * 
		 * @param charIndex
		 * <span lang="ja">文字の 0 から始まるインデックス値です。つまり、最初の位置は 0、2 番目の位置は 1 で、以下同様に続きます。</span>
		 * <span lang="en">The zero-based index value for the character (for example, the first position is 0, the second position is 1, and so on).</span>
		 * @return
		 * <span lang="ja">文字の境界ボックスを定義する x および y の最小値と最大値が指定された矩形です。</span>
		 * <span lang="en">A rectangle with x and y minimum and maximum values defining the bounding box of the character.</span>
		 */
		function getCharBoundaries( charIndex:int ):Rectangle;
		
		/**
		 * <span lang="ja">x および y パラメータで指定されたポイントにある文字の 0 から始まるインデックス値を返します。</span>
		 * <span lang="en">Returns the zero-based index value of the character at the point specified by the x and y parameters.</span>
		 * 
		 * @param x
		 * <span lang="ja">文字の x 座標です。</span>
		 * <span lang="en">The x coordinate of the character.</span>
		 * @param y
		 * <span lang="ja">文字の y 座標です。</span>
		 * <span lang="en">The y coordinate of the character.</span>
		 * @return
		 * <span lang="ja">0 から始まる文字のインデックス値です。例えば、最初の位置は 0、次の位置は 1 と続きます（以下同様）。指定されたポイントがどの文字の上にもない場合は -1 を返します。</span>
		 * <span lang="en">The zero-based index value of the character (for example, the first position is 0, the second position is 1, and so on). Returns -1 if the point is not over any character.</span>
		 */
		function getCharIndexAtPoint( x:Number, y:Number ):int;
		
		/**
		 * <span lang="ja">文字インデックスを指定すると、同じ段落内の最初の文字のインデックスを返します。</span>
		 * <span lang="en">Given a character index, returns the index of the first character in the same paragraph.</span>
		 * 
		 * @param charIndex
		 * <span lang="ja">文字の 0 から始まるインデックス値です。つまり、最初の文字は 0、2 番目の文字は 1 で、以下同様に続きます。</span>
		 * <span lang="en">The zero-based index value of the character (for example, the first character is 0, the second character is 1, and so on).</span>
		 * @return
		 * <span lang="ja">同じ段落内の最初の文字を示す、0 から始まるインデックス値です。</span>
		 * <span lang="en">The zero-based index value of the first character in the same paragraph.</span>
		 */
		function getFirstCharInParagraph( charIndex:int ):int;
		
		/**
		 * <span lang="ja">&lt;img&gt; タグを使用して HTML フォーマットのテキストフィールドに追加されたイメージまたは SWF ファイルについて、指定された id の DisplayObject 参照を返します。</span>
		 * <span lang="en">Returns a DisplayObject reference for the given id, for an image or SWF file that has been added to an HTML-formatted text field by using an &lt;img&gt; tag.</span>
		 * 
		 * @param id
		 * <span lang="ja">照合する id（id 属性（&lt;img&gt; タグ内））。</span>
		 * <span lang="en">The id to match (in the id attribute of the &lt;img&gt; tag).</span>
		 * @return
		 * <span lang="ja">一致する id 属性をテキストフィールドの &lt;img&gt; タグ内に持つイメージまたは SWF ファイルに対応する表示オブジェクトです。外部ソースから読み込まれたメディアの場合、このオブジェクトは Loader オブジェクトであり、いったん読み込まれると、メディアオブジェクトはその Loader オブジェクトの子になります。SWF ファイルに埋め込まれたメディアの場合、これは読み込まれたオブジェクトです。&lt;img&gt; タグの中に一致する id が含まれない場合、このメソッドは null を返します。</span>
		 * <span lang="en">The display object corresponding to the image or SWF file with the matching id attribute in the &lt;img&gt; tag of the text field. For media loaded from an external source, this object is a Loader object, and, once loaded, the media object is a child of that Loader object. For media embedded in the SWF file, it is the loaded object. If no &lt;img&gt; tag with the matching id exists, the method returns null.</span>
		 */
		function getImageReference( id:String ):DisplayObject;
		
		/**
		 * <span lang="ja">x および y パラメータで指定されたポイントにある行の 0 から始まるインデックス値を返します。</span>
		 * <span lang="en">Returns the zero-based index value of the line at the point specified by the x and y parameters.</span>
		 * 
		 * @param x
		 * <span lang="ja">行の x 座標です。</span>
		 * <span lang="en">The x coordinate of the line.</span>
		 * @param y
		 * <span lang="ja">行の y 座標です。</span>
		 * <span lang="en">The y coordinate of the line.</span>
		 * @return
		 * <span lang="ja">0 から始まる行のインデックス値です。例えば、最初の行は 0、次の行は 1 と続きます（以下同様）。指定されたポイントがどの行の上にもない場合は -1 を返します。</span>
		 * <span lang="en">The zero-based index value of the line (for example, the first line is 0, the second line is 1, and so on). Returns -1 if the point is not over any line.</span>
		 */
		function getLineIndexAtPoint( x:Number, y:Number ):int;
		
		/**
		 * <span lang="ja">charIndex パラメータで指定された文字を含む行の 0 から始まるインデックス値を返します。</span>
		 * <span lang="en">Returns the zero-based index value of the line containing the character specified by the charIndex parameter.</span>
		 * 
		 * @param charIndex
		 * <span lang="ja">文字の 0 から始まるインデックス値です。つまり、最初の文字は 0、2 番目の文字は 1 で、以下同様に続きます。</span>
		 * <span lang="en">The zero-based index value of the character (for example, the first character is 0, the second character is 1, and so on).</span>
		 * @return
		 * <span lang="ja">行の 0 から始まるインデックス値です。</span>
		 * <span lang="en">The zero-based index value of the line.</span>
		 */
		function getLineIndexOfChar( charIndex:int ):int;
		
		/**
		 * <span lang="ja">特定のテキスト行内の文字数を返します。</span>
		 * <span lang="en">Returns the number of characters in a specific text line.</span>
		 * 
		 * @param lineIndex
		 * <span lang="ja">長さが必要な行番号です。</span>
		 * <span lang="en">The line number for which you want the length.</span>
		 * @return
		 * <span lang="ja">行内の文字数です。</span>
		 * <span lang="en">The number of characters in the line.</span>
		 */
		function getLineLength( lineIndex:int ):int;
		
		/**
		 * <span lang="ja">指定されたテキスト行に関するメトリック情報を返します。</span>
		 * <span lang="en">Returns metrics information about a given text line.</span>
		 * 
		 * @param lineIndex
		 * <span lang="ja">メトリック情報が必要な行番号です。</span>
		 * <span lang="en">The line number for which you want metrics information.</span>
		 * @return
		 * <span lang="en">TextLineMetrics オブジェクトです。</span>
		 * <span lang="en">A TextLineMetrics object.</span>
		 */
		function getLineMetrics( lineIndex:int ):TextLineMetrics;
		
		/**
		 * <span lang="ja">lineIndex パラメータで指定された行の最初の文字の文字インデックスを返します。</span>
		 * <span lang="en">Returns the character index of the first character in the line that the lineIndex parameter specifies.</span>
		 * 
		 * @param lineIndex
		 * <span lang="ja">0 から始まる行のインデックス値です。例えば、最初の行は 0、次の行は 1 と続きます（以下同様）。</span>
		 * <span lang="en">The zero-based index value of the line (for example, the first line is 0, the second line is 1, and so on).</span>
		 * @return
		 * <span lang="ja">行の最初の文字を示す、0 から始まるインデックス値です。</span>
		 * <span lang="en">The zero-based index value of the first character in the line.</span>
		 */
		function getLineOffset( lineIndex:int ):int;
		
		/**
		 * <span lang="ja">lineIndex パラメータで指定された行のテキストを返します。</span>
		 * <span lang="en">Returns the text of the line specified by the lineIndex parameter.</span>
		 * 
		 * @param lineIndex
		 * <span lang="en">The zero-based index value of the line (for example, the first line is 0, the second line is 1, and so on).</span>
		 * <span lang="ja">0 から始まる行のインデックス値です。例えば、最初の行は 0、次の行は 1 と続きます（以下同様）。</span>
		 * @return
		 * <span lang="en">The text string contained in the specified line.</span>
		 * <span lang="ja">指定された行に含まれるテキストストリングです。</span>
		 */
		function getLineText( lineIndex:int ):String;
		
		/**
		 * <span lang="ja">文字インデックスを指定すると、指定された文字を含む段落の長さを返します。</span>
		 * <span lang="en">Given a character index, returns the length of the paragraph containing the given character.</span>
		 * 
		 * @param charIndex
		 * <span lang="ja">文字の 0 から始まるインデックス値です。つまり、最初の文字は 0、2 番目の文字は 1 で、以下同様に続きます。</span>
		 * <span lang="en">The zero-based index value of the character (for example, the first character is 0, the second character is 1, and so on).</span>
		 * @return
		 * <span lang="ja">段落内の文字数を返します。</span>
		 * <span lang="en">Returns the number of characters in the paragraph.</span>
		 */
		function getParagraphLength( charIndex:int ):int;
		
		/**
		 * <span lang="ja">beginIndex パラメータと endIndex パラメータで指定された範囲のテキストのフォーマット情報を含む TextFormat オブジェクトを返します。</span>
		 * <span lang="en">Returns a TextFormat object that contains formatting information for the range of text that the beginIndex and endIndex parameters specify.</span>
		 * 
		 * @param beginIndex
		 * <span lang="ja">オプション。テキストフィールド内のテキスト範囲の開始位置を指定する整数です。</span>
		 * <span lang="en">Optional; an integer that specifies the starting location of a range of text within the text field.</span>
		 * @param endIndex
		 * <span lang="ja">オプション：該当するテキスト範囲の直後の文字の位置を指定する整数。意図したとおり、beginIndex と endIndex の値を指定すると、beginIndex から endIndex-1 までのテキストが読み込まれます。</span>
		 * <span lang="en">Optional; an integer that specifies the position of the first character after the desired text span. As designed, if you specify beginIndex and endIndex values, the text from beginIndex to endIndex-1 is read.</span>
		 * @return
		 * <span lang="ja">指定されたテキストのフォーマットプロパティを表す TextFormat オブジェクトです。</span>
		 * <span lang="en">The TextFormat object that represents the formatting properties for the specified text.</span>
		 */
		function getTextFormat( beginIndex:int = -1, endIndex:int = -1 ):TextFormat;
		
		/**
		 * <span lang="ja">現在の選択内容を value パラメータの内容に置き換えます。</span>
		 * <span lang="en">Replaces the current selection with the contents of the value parameter.</span>
		 * 
		 * @param value
		 * <span lang="ja">現在選択されているテキストを置き換えるストリングです。</span>
		 * <span lang="en">The string to replace the currently selected text.</span>
		 */
		function replaceSelectedText( value:String ):void;
		
		/**
		 * <span lang="ja">beginIndex パラメータと endIndex パラメータで指定された文字範囲を、newText パラメータの内容に置き換えます。</span>
		 * <span lang="en">Replaces the range of characters that the beginIndex and endIndex parameters specify with the contents of the newText parameter.</span>
		 * 
		 * @param beginIndex
		 * <span lang="ja">置換範囲の開始位置の 0 から始まるインデックス値です。</span>
		 * <span lang="en">The zero-based index value for the start position of the replacement range.</span>
		 * @param endIndex
		 * <span lang="ja">該当するテキスト範囲の直後の文字の 0 から始まるインデックス位置です。</span>
		 * <span lang="en">The zero-based index position of the first character after the desired text span.</span>
		 * @param newText
		 * <span lang="ja">指定された文字範囲の置き換えに使用されるテキストです。</span>
		 * <span lang="en">The text to use to replace the specified range of characters.</span>
		 */
		function replaceText( beginIndex:int, endIndex:int, newText:String ):void;
		
		/**
		 * <span lang="ja">最初の文字と最後の文字のインデックス値によって指定されたテキストを選択済みに設定します。最初の文字と最後の文字のインデックス値は、beginIndex パラメータおよび endIndex パラメータを使用して指定されます。</span>
		 * <span lang="en">Sets as selected the text designated by the index values of the first and last characters, which are specified with the beginIndex and endIndex parameters.</span>
		 * 
		 * @param beginIndex
		 * <span lang="ja">選択範囲の先頭の文字の 0 から始まるインデックス値です。つまり、最初の文字が 0、2 番目の文字が 1 で、以下同様に続きます。</span>
		 * <span lang="en">The zero-based index value of the first character in the selection (for example, the first character is 0, the second character is 1, and so on).</span>
		 * @param endIndex
		 * <span lang="ja">選択範囲の最後の文字を示す、0 から始まるインデックス値です。</span>
		 * <span lang="en">The zero-based index value of the last character in the selection.</span>
		 */
		function setSelection( beginIndex:int, endIndex:int ):void;
		
		/**
		 * <span lang="ja">format パラメータで指定したテキストフォーマットを、テキストフィールド内の指定されたテキストに適用します。</span>
		 * <span lang="en">Applies the text formatting that the format parameter specifies to the specified text in a text field.</span>
		 * 
		 * @param format
		 * <span lang="ja">文字と段落のフォーマット情報を含む TextFormat オブジェクトです。</span>
		 * <span lang="en">A TextFormat object that contains character and paragraph formatting information.</span>
		 * @param beginIndex
		 * <span lang="ja">オプション：該当するテキスト範囲の直後の文字を指定して、ゼロから始まるインデックス位置を指定する整数。</span>
		 * <span lang="en">Optional; an integer that specifies the zero-based index position specifying the first character of the desired range of text.</span>
		 * @param endIndex
		 * <span lang="ja">オプション：該当するテキスト範囲の直後の文字を指定する整数。意図したとおり、beginIndex と endIndex の値を指定すると、beginIndex から endIndex-1 までのテキストが更新されます。</span>
		 * <span lang="en">Optional; an integer that specifies the first character after the desired text span. As designed, if you specify beginIndex and endIndex values, the text from beginIndex to endIndex-1 is updated.</span>
		 */
		function setTextFormat( format:TextFormat, beginIndex:int = -1, endIndex:int = -1 ):void;
	}
}
