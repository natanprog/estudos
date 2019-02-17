# Desenvolver Sistema com Delphi e SQL-Server na PRÁTICA

[Udemy](https://www.udemy.com/desenvolver-sistema-com-delphi-e-sql-server-na-pratica/)  

---
## Ambiente de desenvolvimento 
---

+ [Lubuntu](https://lubuntu.me/) 18.04.1 LTS
+ [fpcupdeluxe](https://github.com/LongDirtyAnimAlf/fpcupdeluxe) Lazarus 2.0.0 Free Pascal 3.0.4
+ Microsoft [SQL Server 2017](https://docs.microsoft.com/pt-br/sql/linux/quickstart-install-connect-ubuntu?view=sql-server-linux-2017) Express Edition
+ [Azure Data Studio](https://docs.microsoft.com/pt-br/sql/azure-data-studio/download?view=sql-server-linux-2017)  

---
### Componentes
---

| Componente                     | Download                                                                               |
| :----------------------------- | :------------------------------------------------------------------------------------- |
| Zeos Library                   | `svn checkout https://svn.code.sf.net/p/zeoslib/code-0/branches/7.2-patches/ zeoslib`  |
| FortesReport Community Edition | `svn checkout https://github.com/fortesinformatica/fortesreport-ce/trunk fortesreport` |
| RX Library                     | `svn checkout https://svn.code.sf.net/p/lazarus-ccr/svn/components/rx/trunk/ rxnew`    |

---
#### Configuração TZConnection
---

```pascal
  ZConnection.Protocol := 'FreeTDS_MsSQL>=2005';
  ZConnection.LibraryLocation := '/usr/lib/x86_64-linux-gnu/libsybdb.so';
```

```bash
  sudo apt install libsybdb5
  sudo ln -sf /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/x86_64-linux-gnu/dblib.so
```