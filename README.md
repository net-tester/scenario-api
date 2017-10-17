# HTTP status code
* 200: GET/POSTで正常処理されたとき
* 400: パラメータエラー
* 404: GETで指定されたidが存在しなかったとき
* 500: その他もろもろエラー

# request data
* Contents-type: application/json
* GET /pingtest
  * id: プロセス番号、数値、必須
  * 例： `{"id":"1"}`
* POST /pingtest
  * vlan_id: テスト対象VLAN番号、数値、必須
  * sites: テスト対象の拠点一覧、文字列の配列、必須
  * dry-run: 0ではない値が指定されたときテスト内容をdry-runする、数値、省略可
  * 例: `{"vlan_id":"2002", "sites":["@hnd0", "@oka0"]}`

# response data
* POST, GETでプロセスが実行中の時
```
{
  "id": 1,
  "status": "created",
  "stdout": "",
  "stderr": ""
}
```
* 完了したとき
```
{
  "id": 1,
  "status": "finished",
  "stdout": "(JSON.parseされる前のstdout)",
  "stderr": "",
  "result": [
    {
      "uri": "(featureファイルの名前)",
      "elements": [
        {
          "before": [
            {
              "match": {
                "location": "aruba-0.14.2/lib/aruba/cucumber/hooks.rb:12"
              },
              "result": {
                "status": "passed",
                "duration": 1033439805
              }
            },
            {
              "match": {
                "location": "aruba-0.14.2/lib/aruba/cucumber/hooks.rb:18"
              },
              "result": {
                "status": "passed",
                "duration": 53291
              }
            }
          ]
        }
      ]
    }
  ]
}
```

