SELECT
    distinct a.banid,a.bantypedesc,a.season,a.sex,a.makedeptname,aa.factorydesc,
    a.makedeptdesc,a.trackdept,a.trackgroupnm,a.tracknm,ISNULL(a.GongyiType,'') AS GongyiType,
    dsgdeptconfirmdate,cancelmanagercheckdate,
    GdbToZyb,GdbToSfz,GdbToSjb,GdbToTcb,GdbToMjs,GdbToCfb,GdbToDgb,GdbToXsb,
    GdbToYhb,GdbToXhb,GdbToZds,GdbToIeb,GdbToMzb,IebToGdb,IebToMzb,IebToZds,
    QabToCfb,QabToXsb,SfzToGdb,SfzToCcz,SfzToZds,SfzToCfz,CczToCfb,CczToGdb,
    CczToMzb,CczToYhb,CczToXhb,CfbToGdb,CfbToMzb,CfbToXsb,CfbToMjb,CfbToZyb,
    CfbToWbz,GybToGdb,GybToCfb,MjsToGdb,MjsToMzb,MjsToCfb,MzbToSjb,MzbToIeb,
    MzbToGdb,MzbToZdb,MzbToCfb,SjbToGdb,SjbToMzb,SjbToZds,TcbToYhb,WbzToQab,
    WbzToGdb,WbzToMzb,WbzToCfb,WbzToXsb,WlcToGdb,WlcToCfb,WlcToZyb,WlcToXsb,
    XsbToSjb,XsbToCfb,XhbToQab,XhbToGdb,XhbToMzb,XhbToCfb,Yxjkb,YhbToGdb,
    YhbToMzb,YhbToCfb,ZybToGdb,ZybToMzb,ZybToZds,ZybToGyb,ZdsToIeb,ZdsToGdb,
    ZdsToMzb,QabToGdb,QabToWbz,XsbToWbz,XsbToGcb,
    CurrDept,CurrDateTime,
    /*,p.styledesc */
    dbo.Get_BanCancel_info(a.banid) as BanCancel_info --是否取消/暂停款
INTO #tmpbanprocess
FROM dsg_bi.dbo.Ban_Process_DateQry a(nolock)
inner join b_styleno p(nolock) on a.banid=p.banid
left join(
    Select distinct a.factorydesc,b.banid
    from DCForward_head(nolock) a
    Left join DCForward_detail(nolock) b on b.dcf_number=a.dcf_number)aa on aa.banid=a.banid
where 1=1
    and p.season  =  '2017冬季'

SELECT * FROM #tmpbanprocess

DROP TABLE #tmpbanprocess

