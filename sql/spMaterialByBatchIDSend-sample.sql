Select cast(0 as bit ) as selectflag,a.BatchID,a.LocationID,a.MatNo,a.MatDesc,a.volumeid,a.Package,
          a.avnoresweight Qtyi,
          a.Wunit as Qunit,a.storelength stocklength,--????
                           a.storeweight stockweight,
          a.Wunit,a.conversion,
          a.avnoreslength   as  Length,
          a.Lunit,
          a.avnoreslength  as usablelength,--????
          a.ColorID,a.ColorDesc, a.mattype,a.Season,a.reqperson as person,
          case when reqd.req_serial is null then a.dsgpoperson else reqd.bantracknm end as dsgpoperson,a.crockid,a.sampleqty,NULL as resno,NULL as resline,a.storeno,
          case when reqd.req_serial is null then a.styleno else reqd.styleno end as styleno,case when reqd.req_serial is null then a.banid else reqd.banid end as templetid ,
          case when a.storeno in ('B','C') then '??' when a.storeno='A' then '??' else '' end as itemtype1,
          '??' as isoldmat,
          a.OrderNo,a.rev_number,reqd.pre_number,reqd.pre_line,reqd.unit as preunit, case when reqd.unit<>a.Lunit and reqd.unit='?' then reqd.fpqty*a.sampleqty/a.conversion
                         else
                            reqd.fpqty end preneedqty, reqd.rtnqty,a.avnoreslength
into #tmpmaterialbatchidsend
          from vm_batchstoreqty a
     left join req_detaild(nolock) reqd on a.orderserial=reqd.req_serial and a.line=reqd.req_line
     left join  MaterialLocationInfo(nolock) k  on a.LocationID = k.locationID 
       where a.isoldmat=1 and a.storelength>0 and a.storeweight>0 and a.avnoreslength >0 and a.avnoresweight>0 and k.lockflag=0 
	   
---------------------------------------------------------------
 select * into #tmpmaterialsend  from (  Select a.*,(isnull(c.outlength,0)+ISNULL(d.sendlength,0)) bcklength,
          case when a.storeno in ('B','C') and a.avnoreslength-((case when a.preunit<>a.Lunit and a.preunit='?' then a.rtnqty*a.sampleqty/a.conversion
    else a.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0
                    then ((case when a.preunit<>a.Lunit and a.preunit='?' then a.rtnqty*a.sampleqty/a.conversion
else a.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))
               when a.storeno in ('B','C') and a.avnoreslength-((case when a.preunit<>a.Lunit and a.preunit='?' then a.rtnqty*a.sampleqty/a.conversion
                  else a.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0 then a.avnoreslength
               when a.storeno in ('A') and a.avnoreslength-(a.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0
                    then  a.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0)
               when a.storeno in ('A') and a.avnoreslength-(a.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0
                    then  a.avnoreslength
               else a.avnoreslength  end as prerestqty
          from #tmpmaterialbatchidsend a
         left join (Select c.pre_number,c.pre_line,SUM(a.length) as outlength from MaterialOut_Detail(nolock) a
						  left join MaterialOut_Head(nolock) b on b.DocNo=a.DocNo
						  left join MaterialSend_DetailD(nolock) c on c.DocNo=b.SendNo and c.BatchID=a.BatchID
						  where c.pre_number+convert(varchar,c.pre_line) in (select pre_number+convert(varchar,pre_line) from #tmpmaterialbatchidsend) and
                     c.resno is null and b.SendNo not like 'BCK%' and c.pre_number is not null
						  group by c.pre_number,c.pre_line
                   ) c on c.pre_number=a.pre_number and c.pre_line=a.pre_line    --???

         left join (Select a.pre_number,a.pre_line,SUM(length) as sendlength
                    from MaterialSend_DetailD(nolock) a
                    inner join MaterialSend_head(nolock) c on c.docno=a.docno
                    left join MaterialOut_Head(nolock) b on b.SendNo=a.DocNo
                    where a.docno like 'SED%' and a.resno is null and b.DocNo is null and a.pre_number is not null
                    and a.pre_number+convert(varchar,a.pre_line) in (select pre_number+convert(varchar,pre_line) from #tmpmaterialbatchidsend)
                     group by a.pre_number,a.pre_line
                    ) d on d.pre_number=a.pre_number and d.pre_line=a.pre_line  --???
                        
 union all 
Select distinct cast(0 as bit ) as selectflag,a.BatchID,a.LocationID,a.MatNo,a.MatDesc,a.volumeid,a.Package,
          a.avnoresweight Qtyi,
          a.Wunit as Qunit,a.storelength stocklength,--????
                           a.storeweight stockweight,
          a.Wunit,a.conversion,
          a.avnoreslength   as  Length,
          a.Lunit,
          a.avnoreslength  as usablelength,--????
          a.ColorID,a.ColorDesc, a.mattype,a.Season,a.reqperson as person,
          case when reqd.req_serial is null then a.dsgpoperson else reqd.bantracknm end as dsgpoperson,a.crockid,a.sampleqty,NULL as resno,NULL as resline,a.storeno,
          case when reqd.req_serial is null then a.styleno else reqd.styleno end as styleno,case when reqd.req_serial is null then a.banid else reqd.banid end as templetid ,
          case when a.storeno in ('B','C') then '??' when a.storeno='A' then '??' else '' end as itemtype1,'??' as isoldmat,
          a.OrderNo,a.rev_number,
          '' pre_number,0 pre_line,'' preunit,reqd.rtnqty,a.avnoreslength,0 preneedqty,0 bcklength,0 prerestqty  from vm_batchstoreqty a
         left join req_detaild reqd(nolock) on a.orderserial=reqd.req_serial and a.line=reqd.req_line
         --left join req_head reqh(nolock) on reqh.req_serial=reqd.req_serial
         left join  MaterialLocationInfo (nolock) k  on a.LocationID = k.locationID
                        
where a.isoldmat=0 and a.storelength>0 and a.storeweight>0 and a.avnoreslength >0 and a.avnoresweight>0
      and k.lockflag=0 
 ) tmp 
 
select * from #tmpmaterialsend