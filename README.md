# MemcachedLocalプラグイン

特にFastCGI環境などでのテンプレートの再構築を高速化を実現するプラグイン。

MemcachedLocalプラグインは、オブジェクトの外部メタデータ(例えば、エントリのコメント数、トラックバック数、タグなど)をキャッシュすることで、特にFastCGI環境などでのテンプレートの再構築を高速化を実現するプラグインです。MT4専用。

## 更新履歴

 * 0.01 (2007-10-01 12:20:43 +0900):
   * 公開。

## 概要

MemcachedLocalプラグインは、オブジェクトの外部メタデータ(例えば、エントリのコメント数、トラックバック数、タグなど)をキャッシュするものです。このため、特にFastCGI環境などでのテンプレートの再構築、例えばmt-search.cgiの表示やアーカイブの再構築、が高速化されます。

CGI環境では意味がありません。また、MT4専用です。

以下はテクニカルな説明です。

----

MTオブジェクトの中には内部データと外部メタデータの両方を持つものがあります。例えば、MT::Entryオブジェクト$entryにおける、$entry->comment_countや$entry->ping_countは、外部メタデータの典型的な例です。これらのプロパティーは、mt_entryテーブルではなく、mt_comment、mt_trackback、mt_tbpingなどの外部テーブルから取得できるものであるためです。当然ですが、内部データにアクセスするのに比べて外部メタデータにアクセスするのにはより長い時間がかかります。

このようなオーバーヘッドを償却し、外部メタデータへのアクセスをなるべく高速化するために、MT4ではMTオブジェクトの外部メタデータに対する、二段階のキャッシュ機構が組み込まれています。

L1キャッシュとしては、MT4は、MTオブジェクトの外部データをオブジェクト内部に保持します。最初に$entry->comment_countを呼び出したとき、MTは外部テーブルを用いてその値を計算し、オブジェクトのプロパティー(実装としては連想配列の要素)として保存します。その後はその値を計算なしに再利用することができます。これはこれで良いのですが、L1キャッシュは、対象となるオブジェクトと同じ寿命(しかも、セッションの寿命より短い寿命)を持ちます。なぜならセッションが完了するたびに、ほとんどのMTオブジェクトはローカルメモリから削除され、それに関連づけられたL1キャッシュエントリも削除されるからです。このため、複数のセッション、あるいは複数のFastCGIリクエストにまたがってL1キャッシュを再利用することはできません。

一方、L2キャッシュとしては、MT4は外部メタデータをMemcachedに格納します。外部メタデータはMemcachedのメモリー内に永続的に保存されるため、その内容を複数のセッションにまたがって再利用することができます。もちろん、この機能が使えるのはMemcachedを導入している場合に限ります。また、外部プロセスであるMemcachedで実現されたL2キャッシュは、Perlのランタイムオブジェクトとして保存されるL1キャッシュに比べて十分に遅くなります。

こうした状況を解決するために、MemcacheLocalプラグインは、Memcachedを使わずにL2キャッシュ機能を実現するものです。MemcachedベースのL2キャッシュと異なり、MemcachedLocalは外部メタデータをローカルメモリに格納し、アプリケーションインスタンスが生存している限りはそれを保持しつづけます。したがって、典型的にはFastCGI環境の下では、アプリケーションは外部テーブルにアクセスすることなく、外部メタデータを再利用できるようになります。

## 使い方

プラグインをインストールするには、パッケージに含まれるMemcachedLocalディレクトリをMovable Typeのプラグインディレクトリ内にアップロードもしくはコピーしてください。正しくインストールできていれば、Movable Typeのメインメニューにプラグインが新規にリストアップされます。

Memcachedが有効な場合には、MemcachedLocalの機能は使えません。mt-config.cgiでMemcachedServersディレクティブを設定しているのなら、コメントアウトする必要があります。

## TODO

 * キャッシュのライフタイムの管理。現在はサボってとにかくキャッシュしているだけ。

## See Also

## License

This code is released under the Artistic License. The terms of the Artistic License are described at [http://www.perl.com/language/misc/Artistic.html](http://www.perl.com/language/misc/Artistic.html).

## Author & Copyright

Copyright 2007, Hirotaka Ogawa (hirotaka.ogawa at gmail.com)
