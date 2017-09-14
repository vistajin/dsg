procedure TfrmBanMakeBillSJB.actPostExecute(Sender: TObject);
var ssql,ssqltmp:string;
   orderid,rzdbrdgrpsn:integer;
   vItemcount,vItemcolorcount,vGoodscount:integer;
   iSex,vcolor_clash,vStyleno:String;
begin
  IsShowProgress := True;

  //判断板单流水号是否重复
  if stateflag='add' then
  begin
    ssql:='select mb_number from ban_makebill_head where mb_number='+QuotedStr(msqHead.FieldByName('mb_number').AsString);
    with qryTemp2 do
    begin
      Close;
      SQL.Text:=ssql;
      Open;
    end;
    if not qryTemp2.IsEmpty then
    begin
       msqHead.FieldByName('mb_number').Value := GetNewKeyNumber('banmakebillnumber','MB');
    end;
  end;

  ShowActiveProgress('检查必填栏位...',9,IsShowProgress);

  //by Mark 2016-7-11 若是转单，则原设计板单号不能为空
  if (Length(trim(edoldBanid.Text))=0) and (edoldBanid.Visible=true) then
  begin
     messagedlg('转单，原设计板单号不能为空!',mtwarning,[mbok],0);
     plProgress.Visible := False;
     abort;
  end;

  if (Trim(edTrackGroupNm.Text) = '') and (edTrackGroupNm.Visible = True) then
  begin
    pcMakeBill.ActivePage:= TabSheet2;
    if edtrackgroupnm.CanFocus then
    edTrackGroupNm.SetFocus;
    messagedlg('跟单组长不能为空!',mtwarning,[mbok],0);
    plProgress.Visible := False;
    abort;
  end;


  if (Trim(edgoods_category.Text) = '') and (edgoods_category.Visible = True) then
  begin
    pcMakeBill.ActivePage:= TabSheet2;
    if edgoods_category.CanFocus then
    edgoods_category.SetFocus;
    messagedlg('商品类别不能为空!',mtwarning,[mbok],0);
    plProgress.Visible := False;
    abort;
  end;

  if (Trim(eddesign_element.Text) = '') and (eddesign_element.Visible = True) then
  begin
    pcMakeBill.ActivePage:= TabSheet2;
    if eddesign_element.CanFocus then
    eddesign_element.SetFocus;
    messagedlg('设计元素不能为空!',mtwarning,[mbok],0);
    plProgress.Visible := False;
    abort;
  end;

  if (Trim(edtrackdept.Text) = '') and (edtrackdept.Visible = True) then
  begin
    pcMakeBill.ActivePage:= TabSheet2;
    if edtrackdept.CanFocus then
    edtrackdept.SetFocus;
    messagedlg('跟单部门不能为空!',mtwarning,[mbok],0);
    plProgress.Visible := False;
    abort;
  end;

  if (Trim(edInDept.Text) = '') and (edtrackdept.Visible = True) then
  begin
    pcMakeBill.ActivePage:= TabSheet2;
    if edInDept.CanFocus then
    edInDept.SetFocus;
    messagedlg('开单部门不能为空!',mtwarning,[mbok],0);
    plProgress.Visible := False;
    abort;
  end;

  if (Trim(edtSex.Text) = '') and (edtrackdept.Visible = True) then
  begin
    pcMakeBill.ActivePage:= TabSheet2;
    if edtSex.CanFocus then
    edtSex.SetFocus;
    messagedlg('性别不能为空!',mtwarning,[mbok],0);
    plProgress.Visible := False;
    abort;
  end;

  //cyueyong 2015-08-11
  if (rgdlfs.ItemIndex < 0) and (rgdlfs.Visible = True) then
  begin
    messagedlg('出板标记未选择,需选择出板标记!',mtwarning,[mbok],0);
    plProgress.Visible := False;
    abort;
  end;

  //头板+齐色
  //if msqHead.FieldByName('mbtypeid').AsString='MBT07' then
  // CheckStyleNoinf;

  if (Trim(edbasesizem.Text) = '') and (edbasesizem.Visible = True) then
  begin
    pcMakeBill.ActivePage:= tbShuLiang;
    if edbasesizem.CanFocus then
    edbasesizem.SetFocus;
    messagedlg('基码不能为空!',mtwarning,[mbok],0);
    plProgress.Visible := False;
    abort;
  end;

  if (strtointdef(copy(msqhead.FieldByName('mbversion').AsString,3,2),0)>1 ) and (edMbVersion.Visible = True) then
  begin
    if Trim(edverremark.Text) = '' then
    begin
      pcMakeBill.ActivePage:= TabSheet2;
     if edverremark.CanFocus then
      edverremark.SetFocus;
      messagedlg('更新单内容不能为空!',mtwarning,[mbok],0);
      plProgress.Visible := False;
      abort;
    end;
  end;
//

  if (rzdbrdgrpiscontinue.ItemIndex < 0) and (rzdbrdgrpiscontinue.Visible = True) then
     begin
       messagedlg('请选择是否延续款!',mtwarning,[mbok],0);
       rzdbrdgrpiscontinue.SetFocus;
       plProgress.Visible := False;
       abort;
     end;

  if (rzdbrdgrpiscontinue.Visible = True) then
  begin
    if (rzdbrdgrpiscontinue.Items[rzdbrdgrpiscontinue.ItemIndex]='是') then
     begin
      if Trim(edediscontinuestyleno.Text) = '' then
      begin
        edediscontinuestyleno.SetFocus;
        messagedlg('延续款单号不能为空!',mtwarning,[mbok],0);
        plProgress.Visible := False;
        abort;
      end;
      msqHead.Edit ;
      msqHead.FieldByName('iscontinue').Value := 1 ;
      msqHead.Post ;
     end
    else
     begin
      msqHead.Edit ;
      msqHead.FieldByName('iscontinue').Value := 0 ;
      edediscontinuestyleno.Value:='否';
      msqHead.Post ;
     end;
  end;
//

  if (rzdbrdgrpissimilar.ItemIndex < 0) and (rzdbrdgrpissimilar.Visible = True) then
     begin
       messagedlg('请选择是否相似款!',mtwarning,[mbok],0);
       rzdbrdgrpissimilar.SetFocus;
       plProgress.Visible := False;
       abort;
     end;

  if (rzdbrdgrpiscontinue.Visible = True) then
  begin
    if rzdbrdgrpissimilar.Items[rzdbrdgrpissimilar.ItemIndex]='是' then
      begin
        if Trim(edissimilarno.Text) = '' then
        begin
          edissimilarno.SetFocus;
          messagedlg('相似款单号不能为空!',mtwarning,[mbok],0);
          plProgress.Visible := False;
          abort;
        end;
        msqHead.Edit ;
        msqHead.FieldByName('issimilar').Value := 1 ;
        msqHead.Post ;
      end
    else
      begin
       msqHead.Edit ;
       msqHead.FieldByName('issimilar').Value := 0 ;
       edissimilarno.Value:='无';
       msqHead.Post ;
      end;
  end;
//
{
  if rzgrpisOkBanFlag.ItemIndex < 0 then
     begin
       messagedlg('请选择是否已有OK版型!',mtwarning,[mbok],0);
       rzgrpisOkBanFlag.SetFocus;
       plProgress.Visible := False;
       abort;
     end;

  if rzgrpisOkBanFlag.Items[rzgrpisOkBanFlag.ItemIndex]='是' then
    begin
      if Trim(edOkBanRefNo.Text) = '' then
      begin
        edOkBanRefNo.SetFocus;
        messagedlg('OK版参考版型不能为空!',mtwarning,[mbok],0);
        plProgress.Visible := False;
        abort;
      end;
      msqHead2.Edit ;
      msqHead2.FieldByName('OkBanFlag').Value := 1 ;
      msqHead2.Post ;
    end
  else
    begin
     msqHead2.Edit ;
     msqHead2.FieldByName('OkBanFlag').Value := 0 ;
     edOkBanRefNo.Value:='无';
     msqHead2.Post ;
    end;
}
  if (msqHead.FieldByName('mbtypeid').AsString='MBT07') and (edsalesSeason.Text > '2018春季') then //2018春季以前不限制 参考版型
  if (edOkBanRefNo.Visible = True) then
  begin
    if (Trim(edOkBanRefNo.Text)='') AND (edtPPTtype.Text<>'ODM单') then
    begin
      edOkBanRefNo.SetFocus;
      messagedlg('参考版型不能为空!',mtwarning,[mbok],0);
      plProgress.Visible := False;
      abort;
    end
    else
    begin
      if CheckBanRefNo=False then
      begin
        messagedlg('参考版型编号不正确!',mtwarning,[mbok],0);
        plProgress.Visible := False;
        abort;
      end;
      msqHead2.Edit ;
      msqHead2.FieldByName('OkBanFlag').Value := 1 ;
      msqHead2.Post ;
    end;
  end;
//

  if (edtPPTtype.Text='ODM单') and (edODMfactory.Text='') and (edODMfactory.Visible = True) then // by Mark 2016-5-18 ODM单 ODM工厂、ODM外发组不能为空
  begin
    pcMakeBill.ActivePage:= TabSheet2;
    if edODMfactory.CanFocus then
       edODMfactory.SetFocus;
    messagedlg('ODM单 ODM工厂、ODM外发组不能为空!',mtwarning,[mbok],0);
    plProgress.Visible := False;
    abort;
  end;

  if (edtPPTtype.Text='ODM单') and (edODMgroup.Text='') and (edODMgroup.Visible = True) then // by Mark 2016-5-18 ODM单 ODM工厂、ODM外发组不能为空
  begin
    pcMakeBill.ActivePage:= TabSheet2;
    if edODMgroup.CanFocus then
       edODMgroup.SetFocus;
    messagedlg('ODM单 ODM工厂、ODM外发组不能为空!',mtwarning,[mbok],0);
    plProgress.Visible := False;
    abort;
  end;

  //检查羽绒款或者充棉款，必须做'主布防绒处理' 或者 '双层胆布'
  if CheckFrSd=False then
  begin
    plProgress.Visible := False;
    abort;
  end;

  {***********************************************
    by Mark 2015-12-4 begin
    建议价必须在[季度价格段设置]的价位范围，
    而且款数不能超过规定的款数。
    从2017春季开始执行。
   ***********************************************}
  // 检查 建议价是否在[季度价格段设置]的价位范围，而且款数不能超过规定的款数。
  //if (edSeason.Text>'2017') AND ((edSeries.Text='童装') or (edSeries.Text='休闲一')) then
  //头板+齐色
  if msqHead.FieldByName('mbtypeid').AsString='MBT07' then
  begin
    if edsalesSeason.Text <> '2018春季' then //by Mark 2017-5-28 2018春季暂时放开
    begin
      if (edSeason.Text>'2017') AND (edSeries.Text='休闲一') AND (edstylenametype.Text<>'配衬') AND
         ((POS('计划单',edtPPTtype.Text)>0) or (POS('正单',edtPPTtype.Text)>0))
      then
      begin
        ShowActiveProgress('检查建议价是否在规定范围...',25,IsShowProgress);
        IF CheckPriceCount()<>'OK' THEN
        begin
          ShowMesStr('[季度价格段设置]找不到该价位,或者已下单款数大于计划款数：季度='+edSeason.Text +'；款式大类='+edstylenametype.Text
              +'；性别='+edtSex.Text+'；类型='+edstyletype2.Text,'030');
          plProgress.Visible := False;
          Exit;
        end;
      end;
    end;
  end;
  {* by Mark 2015-12-4 end *}


  ShowActiveProgress('自动生成款式名称...',27,IsShowProgress);
  //生成款式名称2015-09-21 cyueyong
  CheckStylenametype;
   

    //头板+齐色
  if msqHead.FieldByName('mbtypeid').AsString='MBT07' then
  begin
    if uppercase(dmmain.BHUserManager1.LoginID)<>'SA' THEN
    if uppercase(edInUser.Text)<> uppercase(dmmain.BHUserManager1.Loginname) then
    begin
     // if rgdlfs.ItemIndex<0 then
      begin
        if not FChangeOtherUserInf then
        begin
           ShowMesStr('你没有修改其他人资料的权限!','030');
           plProgress.Visible := False;
           Exit;
        end;
      end ;
    end;
  end;

  //头板+齐色
  if msqHead.FieldByName('mbtypeid').AsString='MBT07' then
  begin
    ShowActiveProgress('检查成品及物料颜色...',31,IsShowProgress);

    if CheckGoodsColor then
    begin
      ShowMesStr('数量分配中存在重复的颜色,无法保存!','030');
      plProgress.Visible := False;
      Abort;
    end;

    //by Mark 2016-10-29 判断需配色的主布物料颜色是否在季度可用颜色中
    if CheckClothItemColor then
    begin
      plProgress.Visible := False;
      Abort;
    end;


    // 2015-12-12 by Mark 系统自动计算颜色个数
    with xqInfo do
      begin
        Close;
        SQL.Clear;
        //SQL.Text := 'select COUNT(color_name) as colorqty from ban_makebill_goods where MB_NUMBER = '+Quotedstr(edMbNumber.Text) ;
        SQL.Text := ' select COUNT(color_name) as colorqty from Goods '
                   +' where MB_NUMBER = '+Quotedstr(edMbNumber.Text)
                   +' and (iscancelcolor is null or iscancelcolor=False) ' ;

        Open;
        if not IsEmpty then
          ediscolorqty.Value:=FieldByName('colorqty').AsString;
      end;
  end
  ELSE
  //板型款
  if msqHead.FieldByName('mbtypeid').AsString='MBT13' then
  begin
    with msqGoods do
    begin
      first;
      if FieldByName('color_name').AsString='' then
      begin
         ShowMesStr('行号'+fieldbyname('mb_line').asstring+'成品色号空白,无法保存!','030');
         plProgress.Visible := False;
         exit;
      end;
    end;
  end;

  ShowActiveProgress('自动生成款号...',35,IsShowProgress);

  tvGroup.OnChange := nil;
  with msqHead do
  begin
    Edit;
    FieldByName('modifyuser').Value := dmmain.BHUserManager1.Loginname;
    FieldByName('modifydate').Value := GetNowTime;
    FieldByName('iscolorqty').Value := ediscolorqty.Text;
    
    //头板+齐色自动生成styleno 2017-5-12 by xm
    if trim(edMbtypeid.text)='MBT07' then
    if copy(trim(edsalesSeason.Text),1,4)>='2018' then //2018以前的不自动生成styleno
    begin
       vStyleno := getStylenoCode(trim(edSeries.text),trim(edsalesSeason.Text),trim(edtSex.Text),
                                                  trim(edfabname.Text),trim(edstylenametype.text),
                                                  trim(edCollartype.Text),trim(edoutsidesleeve.text) ,
                                                  trim(edDesign_style.Text),trim(edthickness.Text),
                                                  trim(edBX_length.Text),trim(edPeichenClass.text),
                                                  trim(edPants_type.text),trim(edtPPTtype.text),
                                                  trim(edstyleno2.text),trim(edMbVersion.text),trim(edstyletype2.text));

       if vStyleno='' then
       begin
         ShowMesStr('自动生成新款号错误!','030');
         plProgress.Visible := False;
         exit;
       end;

       //新开单款号 按系统自动生成，否则，不修改款号
       if (edMbVersion.Text='') then
       begin
          FieldByName('styleno').Value :=vStyleno;
       end;


       {if length(trim(FieldByName('styleno').asstring))<13 then
       begin
         ShowMesStr('系统自动生成的款号不足13位,无法保存!请联系电脑部','030');
         plProgress.Visible := False;
         exit;
       end; }
    end;

    if (trim(FieldByName('styleno').asstring)='') and
       (trim(msqHead.FieldByName('mbtypeid').AsString)='MBT07') then
    begin
      ShowMesStr('款号不能为空!','030');
// if copy(trim(edsalesSeason.Text),1,4)<'2018' then
      begin
        edStyleNo.readonly:=false;
        if edStyleNo.canfocus then
           edStyleNo.setfocus;
      end;
      plProgress.Visible := False;
      exit;
    end;
    Post;
  end;

  ShowActiveProgress('检查款号必填字段及款号属性...',37,IsShowProgress);
  //头板+齐色
  if msqHead.FieldByName('mbtypeid').AsString='MBT07' then
     CheckStyleNoinf;

  with msqHead2 do
  begin
    Edit;
    //新增、修改“新款号”字段
    FieldByName('styleno2').Value :=vStyleno;
    FieldByName('mb_number').Value := msqHead.FieldByName('mb_number').AsString;
    FieldByName('matioid').Value := msqHead.FieldByName('matioid').AsString;
    FieldByName('sc_number').Value := msqHead.FieldByName('sc_number').AsString;
// FieldByName('styleno2').Value := msqHead.FieldByName('styleno').AsString;
    FieldByName('inUserId').Value := dmmain.BHUserManager1.LoginId;
    FieldByName('inUserName').Value := dmmain.BHUserManager1.Loginname;
    FieldByName('indate').Value := GetNowTime;
    Post;
  end;

  ShowActiveProgress('提交数据...',41,IsShowProgress);

  //if msqHead.State in [dsInsert,dsEdit] then
    //msqHead.Post;
  if msqDetail.State in [dsInsert,dsEdit] then //物料清单ban_makebill_itemlist
    msqDetail.Post;
  if msqWorkDes.State in [dsInsert,dsEdit] then //工艺指示ban_makebill_workdes
    msqWorkDes.Post;
  if msqSizeDes.State in [dsInsert,dsEdit] then //尺寸指示ban_makebill_sizedes
    msqSizeDes.Post;
  if msqGoods.State in [dsInsert,dsEdit] then //成品颜色及件数ban_makebill_goods
    msqGoods.Post;
 // if msqorderqty.State in [dsInsert,dsEdit] then
 // msqorderqty.Post;
  if msqItemColor.State in [dsInsert,dsEdit] then //ban_makebill_itemcolor
    msqItemColor.Post;

  //印花+光碟 or 绣花
  if (edisyxh.Checked) or
     (edisyxh1.Checked) then
  begin
      if msqWorkDes.RecordCount<=0 then
      begin
        messagedlg('工艺指示不能为空!',mtwarning,[mbok],0);
        plProgress.Visible := False;
        abort;
      end;
  end;

  //头板+齐色
  if msqHead.FieldByName('mbtypeid').AsString='MBT07' then
  begin
    ShowActiveProgress('检查成品及物料颜色...',43,IsShowProgress);

    if edtPPTtype.Text<>'ODM单' then // by Mark 2016-5-18 ODM单不管控物料清单、工艺指示、包装/洗水说明的内容
    begin
       ssql:=dmmain.GetDescText('ischeckbancolorisnull');
       ssql:=StringReplace(sSQL,':season',quotedstr(msqHead.FieldByName('season').AsString),[rfIgnoreCase,rfReplaceAll]);
      qry1.close;
      qry1.sql.Text:=ssql;
      qry1.open;
      if not qry1.IsEmpty then
      begin
        with msqItemColor do
        begin
          first;
          vItemcolorcount:=0; //物料颜色个数

          while not eof do
          begin
           vItemcolorcount:=vItemcolorcount+1;
           ShowActiveProgress('检查物料配色...',45+vItemcolorcount,IsShowProgress);

           if fieldbyname('isassigncolor').asboolean then
           begin
               if fieldbyname('itemcolorid').asstring='' then
               begin
                 ShowMesStr('行号'+fieldbyname('mb_line').asstring+'物料需配色色号不能空白,无法保存!','030');
                 plProgress.Visible := False;
                 exit;
               end;
           end;
           next;
          end;
        end;
      end;
    end;

    ssql:=dmmain.GetDescText('ischeckbanjscoloroverseason');
    ssql:=StringReplace(sSQL,':season',quotedstr(msqHead.FieldByName('season').AsString),[rfIgnoreCase,rfReplaceAll]);
    qry1.close;
    qry1.sql.Text:=ssql;
    qry1.open;
    if not qry1.IsEmpty then
    begin
       ssqltmp:=dmmain.GetDescText('ischeckcolorisjs');

        with msqItemColor do
        begin
          first;
          vItemcolorcount:=0; //物料颜色个数

          while not eof do
          begin
            vItemcolorcount:=vItemcolorcount+1;
            ShowActiveProgress('检查物料色号...',55+vItemcolorcount,IsShowProgress);

            ssql:= ssqltmp;
            ssql:=StringReplace(ssql,':color_name',quotedstr(FieldByName('itemcolorid').AsString),[rfIgnoreCase,rfReplaceAll]);
            qry1.close;
            qry1.sql.Text:=ssql;
            qry1.open;
            if not qry1.IsEmpty then
            begin
                 ShowMesStr('季度大于2016春季,行号'+fieldbyname('mb_line').asstring+'物料色号'+fieldbyname('itemcolorid').asstring+'属于01-11以纯延用色卡,无法保存!','030');
                 plProgress.Visible := False;
                 exit;
            end;
           next;
          end;
        end;

        ShowActiveProgress('检查成品色号...',61,IsShowProgress);
        with msqGoods do
        begin
          first;
          vGoodscount:=0; //成品个数

          if FieldByName('color_name').AsString='' then
          begin
             ShowMesStr('行号'+fieldbyname('mb_line').asstring+'成品色号空白,无法保存!','030');
             plProgress.Visible := False;
             exit;
          end;
          
          while not eof do
          begin
            vGoodscount:=vGoodscount+1;
            ShowActiveProgress('检查成品色号...',61+vGoodscount,IsShowProgress);

            ssql:= ssqltmp;
            ssql:=StringReplace(ssql,':color_name',quotedstr(FieldByName('color_name').AsString),[rfIgnoreCase,rfReplaceAll]);
            qry1.close;
            qry1.sql.Text:=ssql;
            qry1.open;
            if not qry1.IsEmpty then
            begin
                 ShowMesStr('季度大于2016春季,行号'+fieldbyname('mb_line').asstring+'成品色号'+fieldbyname('color_name').asstring+'属于01-11,无法保存!','030');
                 plProgress.Visible := False;
                 exit;
            end;
           next;
          end;
        end;
    end;

    ShowActiveProgress('检查板单资料是否重复...',68,IsShowProgress);

    with qryTemp2 do
    begin
         close;
         sql.Text:='select * from ban_makebill_head a(nolock) where a.mb_number<>'''+msqHead.FieldByName('mb_number').AsString+''' '
         +' and isnull(a.sc_number,'''')='''+msqHead.FieldByName('sc_number').AsString+''' '
      // +' and isnull(a.styleno,'''')='''+msqHead.FieldByName('styleno').AsString+''' '
         +' and isnull(a.matioid,'''')='''+msqHead.FieldByName('matioid').AsString+''' '
         +' and isnull(a.mbversion,'''')='''+msqHead.FieldByName('mbversion').AsString+''' '
         +' and a.mbtypeid='''+msqHead.FieldByName('mbtypeid').AsString+''' '
         +' and isnull(a.isdlflag,'''')='''+msqHead.FieldByName('isdlflag').AsString+''' '
         +' and isnull(a.xxxfield,'''')='''+msqHead.FieldByName('xxxfield').AsString+''' ';
         open;
         if not IsEmpty then
         begin
           messagedlg('款号流水号'+msqHead.FieldByName('sc_number').AsString
      // +'款号'+msqHead.FieldByName('styleno').AsString
           +'板单号'+msqHead.FieldByName('matioid').AsString
           +'板类'+msqHead.FieldByName('mbtypeid').AsString
           +'版本'+msqHead.FieldByName('mbversion').AsString
           +'重复，请选择款号资料!',mtinformation,[mbok],0 );
           if edMatIoId.CanFocus then
           edMatIoId.SetFocus;
           plProgress.Visible := False;
           Exit;
         end;
    end;

    if edtPPTtype.Text<>'ODM单' then // by Mark 2016-5-18 ODM单不管控物料清单、工艺指示、包装/洗水说明的内容
    begin
    with msqDetail do
    begin
      First;
      vItemcount:=0; //物料个数

      while not Eof do
      begin
        vItemcount:=vItemcount+1;
        ShowActiveProgress('检查物料清单及配色资料...',68+vItemcount,IsShowProgress);

        if fieldbyname('des3').AsString='' then
        begin
           messagedlg('物料清单序号'+fieldbyname('orderid').AsString+'部位空白,不可保存!',mtinformation,[mbok],0 );
           plProgress.Visible := False;
           Exit;
        end;
        // Mark 2015-11-30 控制修身款下身必须要弹力
        if (edstylenametype.Text='裙类') or (edstylenametype.Text='裤类') then
        begin
          //cyueyong 2015-11-18 控制修身款 物料名称是否有弹力或微弹
          Checkbuwei(msqdetail.FieldbyName('mb_line').Value,msqdetail.FieldbyName('item_code').AsString,msqdetail.FieldbyName('Itemtypedesc').AsString,msqdetail.FieldbyName('item_desc').AsString,msqdetail.FieldbyName('des3').AsString,msqhead.FieldbyName('banxing').AsString);
        end;
        //cyueyong 2015-08-14 增加对主料布封的判断
        Checkmodel(msqDetail.fieldbyname('orderid').AsString,msqdetail.FieldbyName('Itemtypedesc').AsString,msqdetail.FieldbyName('item_code').AsString,msqdetail.FieldbyName('model').AsString);
        {if (msqdetail.FieldbyName('Itemtypedesc').AsString='主料') and ((msqdetail.FieldbyName('model').AsString='') or (msqdetail.FieldbyName('model').AsString=null))then
        begin
           messagedlg('物料清单序号'+fieldbyname('orderid').AsString+',布封不能为空!',mtinformation,[mbok],0 );
           Exit;
        end;}

        //by Mark 2017-7-19
        //判断女装、修身、弹力、牛仔下装的主布是否在QA测试OK范围内
        if (pos('女装',edtSex.Text)>0) AND (pos('修身',edbanxing.Text)>0) AND
           (pos('弹力',edfabcharacter.Text)>0) AND (pos('牛仔下装',edtStyletype.Text)>0) AND
           (pos('主布',msqdetail.FieldByName('des3').AsString)>0)
        then
        begin
           sSQL:=dmMain.GetDescText('qryselectitem_codebyQApassDNNFlag');
           sSQL:= StringReplace(sSQL, ':item_code', quotedstr(msqdetail.FieldByName('item_code').AsString),[rfReplaceAll, rfIgnoreCase]);
           qrytemp.Close;
           qrytemp.SQL.Text:=sSQL;
           qrytemp.Open;

           if qrytemp.IsEmpty then
           begin
             messagedlg('女装修身弹力牛仔下装的主布不在QA测试OK范围内！',mtinformation,[mbok],0);
             plProgress.Visible := False;
             exit;
           end;
        end;

        //cyueyong 2015-08-12 增加可用颜色判断
        xqInfo.SQL.Text:='select * from msqItemColor '
                         +' where mb_number='''+fieldbyname('mb_number').AsString+''' and mb_line='+fieldbyname('mb_line').AsString+' ';
        xqInfo.Open;
        if xqInfo.IsEmpty then
        begin
           messagedlg('物料清单序号'+fieldbyname('orderid').AsString+'配色资料有异常,请查看配色资料!',mtinformation,[mbok],0 );
           plProgress.Visible := False;
           Exit;
        end
        else
        begin
           xqInfo.First;
           While not xqInfo.Eof do
           begin

              CheckitemcodenotUseColor(msqdetail.FieldbyName('mb_line').Value,msqdetail.FieldbyName('Itemtypedesc').AsString,msqdetail.FieldbyName('item_code').AsString,xqInfo.FieldByName('itemcolorid').AsString);
              CheckSeasonCanUseColor(msqdetail.FieldbyName('mb_line').Value,msqdetail.FieldbyName('Itemtypedesc').AsString,msqhead.FieldByname('season').AsString,xqInfo.FieldByName('itemcolorid').AsString,xqInfo.FieldByName('itemcolordesc').AsString,xqInfo.FieldByName('item_code').AsString,xqInfo.FieldByName('isassigncolor').Value);
              xqInfo.Next;
           end;
        end;


        qry1.SQL.Text:=' select * '
                    +' from b_itemcanuse_detail a1 (nolock) inner join '
                    +' b_itemcanuse_head a2(nolock) on a1.icu_number=a2.icu_number '
                    +' where a2.confirmflag=1 and isnull(a1.isstopped,0)=0 and '
                    +' (a2.season='''+msqhead.fieldbyname('Season').AsString+''' or a2.season=''通用季'') and '
                    +' a1.item_code='''+fieldbyname('item_code').AsString+'''';
        qry1.Open;
        IF qry1.IsEmpty THEN
        BEGIN
           messagedlg('物料序号'+fieldbyname('orderid').AsString+'物料编号'+fieldbyname('item_code').AsString+'不在可用季度内或已停用,不可保存!',mtinformation,[mbok],0 );
           plProgress.Visible := False;
           Exit;
        end;

        xqInfo.SQL.Text:='select count(*) as colorcount from msqItemColor '
                         +' where mb_number='''+fieldbyname('mb_number').AsString+''' and mb_line='+fieldbyname('mb_line').AsString+' ';
        xqInfo.Open;
        if xqInfo.IsEmpty then
        begin
           messagedlg('物料清单序号'+fieldbyname('orderid').AsString+'配色资料有异常,请查看配色资料!',mtinformation,[mbok],0 );
           plProgress.Visible := False;
           Exit;
        end
        else if xqInfo.FieldByName('colorcount').AsInteger<>msqGoods.RecordCount then
        begin
           messagedlg('物料清单序号'+fieldbyname('orderid').AsString+'配色资料有异常,请查看配色资料!',mtinformation,[mbok],0 );
           plProgress.Visible := False;
           Exit;
        end;

        //by Mark 2017-1-20 快单类的主料必须是大货用过的，不能用新材料
        {
        if (POS('快单',edtPPTtype.Text)>0) or (POS('二次订货',edtPPTtype.Text)>0) then
        begin
           CheckKDitemCanUse(msqdetail.FieldbyName('mb_line').Value,msqdetail.FieldbyName('Itemtypedesc').AsString,msqdetail.FieldbyName('item_code').AsString);
        end;
        }
        next;
      end;
    end;
    end;

    with xqInfo do
    begin
       sql.Text:=' select * from Goods where istouban=true ';
       open;
       if isempty then
       begin
         messagedlg('请在成品颜色及件数画面，指定一个头板色',mtinformation,[mbok],0 );
         plProgress.Visible := False;
         exit;
       end;
    end;

    ShowActiveProgress('解锁中...',79,IsShowProgress);
    FModifyLockFlag := '';
    UnLockItemInf;
  end;
 { with msqorderqty do
  begin
    First;
    orderid:=1;
    while not Eof do
    begin
      edit;
      FieldByName('mb_line').value:= orderid;
      post;
      inc(orderid);
      Next;
    end;
    First;
  end; }

  //头板+齐色
  if msqHead.FieldByName('mbtypeid').AsString='MBT07' then
  begin
    with msqSizeDes do
    begin
      First;
      orderid:=1;
      while not Eof do
      begin
        edit;
        FieldByName('orderid').value:= orderid;
        post;
        inc(orderid);
        Next;
      end;
      First;
    end;

    with msqWorkDes do
    begin
      First;
      orderid:=1;
      while not Eof do
      begin
        edit;
        FieldByName('orderid').value:= orderid;
        post;
        inc(orderid);
        Next;
      end;
      First;
    end;

    with msqDetail do
    begin
      First;
      orderid:=1;
      while not Eof do
      begin
        edit;
        FieldByName('orderid').value:= orderid;
        post;
        inc(orderid);
        Next;
      end;
      First;
    end;
  end;

  //板型款，生成板型编号
  if (msqHead.FieldByName('mbtypeid').AsString='MBT13') and (stateflag='add') then
  begin
     CreateBXnumber;
  end;

  ShowActiveProgress('提交数据...',87,IsShowProgress);

  msqHead.ApplyUpdates;
  msqHead2.ApplyUpdates;
  msqDetail.ApplyUpdates;
  msqWorkDes.ApplyUpdates;
  msqSizeDes.ApplyUpdates;
  msqGoods.ApplyUpdates;
 // msqorderqty.ApplyUpdates;
  msqItemColor.ApplyUpdates;

  msqHead.CommitUpdates;
  msqHead2.CommitUpdates;
  msqDetail.CommitUpdates;
  msqWorkDes.CommitUpdates;
  msqSizeDes.CommitUpdates;
  msqGoods.CommitUpdates;
 // msqorderqty.CommitUpdates;
  msqItemColor.CommitUpdates;

  //头板+齐色
  if msqHead.FieldByName('mbtypeid').AsString='MBT07' then
  begin
    ssql:=dmMain.GetDescText('updatebanqiantao') ;
    ssql:=StringReplace(sSQL,'@tablename',Fbanqiantaotmptb,[rfIgnoreCase,rfReplaceAll]);
    ssql:=StringReplace(sSQL,':mb_number',quotedstr(msqHead.FieldByName('mb_number').AsString),[rfIgnoreCase,rfReplaceAll]);
    qry1.SQL.Text:= ssql;
    qry1.ExecSQL;

    ssql:=dmMain.GetDescText('updatebanqiantaocolor') ;
    ssql:=StringReplace(sSQL,'@tablename',Fbanqiantaocolortmptb,[rfIgnoreCase,rfReplaceAll]);
    ssql:=StringReplace(sSQL,':mb_number',quotedstr(msqHead.FieldByName('mb_number').AsString),[rfIgnoreCase,rfReplaceAll]);
    qry1.SQL.Text:= ssql;
    qry1.ExecSQL;

    ssql:=dmMain.GetDescText('checkchmchrinf') ;
    ssql:=StringReplace(sSQL,':mb_number',quotedstr(msqHead.FieldByName('mb_number').AsString),[rfIgnoreCase,rfReplaceAll]);
    qry1.SQL.Text:= ssql;
    qry1.ExecSQL;

   // saveeditlogtonotice(msqHead.FieldByName('mb_number').AsString);
    ShowActiveProgress('更新颜色资料...',93,IsShowProgress);
    try
      with qrytemp do
      begin
       sql.Text:='exec sp_banupdatetrackandorderproc '''+msqhead.fieldbyname('mb_number').AsString+''' ';
       ExecSQL;
      end;
    except
      on e:exception do
      begin
        messagedlg('更新进度颜色资料出错,'+e.Message,mtwarning,[mbOK],0);
        plProgress.Visible := False;
      end;
    end ;

    updategoodsqty; //更新颜色件数

    //判断撞色 (深撞浅 or 深撞深)
    if iscolor_clash()<>'' then
    begin
      vcolor_clash:= iscolor_clash();
      Showmessage(vcolor_clash);
      //更新板单撞色信息(ban_makebill_zs)
      with qrytemp do
      begin
         Close;
         SQL.Clear;
         SQL.Add('exec sp_updban_makebill_zs :mb_number,:banid,:sc_number,:ZSInfo ');
         Parameters[0].Value:= msqHead.FieldByName('mb_number').Value;
         Parameters[1].Value:= msqHead.FieldByName('matioid').Value;
         Parameters[2].Value:= msqHead.FieldByName('sc_number').Value;
         Parameters[3].Value:= vcolor_clash;
         ExecSQL;
      end;
    end;
  end;

  ShowActiveProgress('保存日志...',99,IsShowProgress);
  try
    with qrytemp do
    begin
     sql.Text:='exec spsavebaneditlog :mb_number,:loginname,:edittype';
     Parameters[0].Value:=msqhead.fieldbyname('mb_number').AsString;
     Parameters[1].Value:=getusername(dmmain.BHUserManager1.LoginId);
     if stateflag='add' then
     Parameters[2].Value:='新增'
     else if stateflag='edit' then
     Parameters[2].Value:='修改';
     ExecSQL;
    end;
  except
    on e:exception do
    begin
      messagedlg('保存日志出错,'+e.Message,mtwarning,[mbOK],0);
      plProgress.Visible := False;
    end;
  end ;


  stateflag:='';
  FEditModel:=0;
  SetButtonStat(1);
  //ActiveDataSet(msqHead.FieldByName('mb_number').AsString);
  ShowMesStr('板单:'+msqHead.FieldByName('mb_number').AsString+' 保存成功!','010');
  with qryBase do
  begin
    Append;
    FieldByName('parientid').Value := 'BAN';
    FieldByName('treeid').Value := Trim(edMbNumber.Text);
   // if rgdlfs.ItemIndex>=0 then
   // FieldByName('mb_desc').Value := edMatIoId.Text+rgdlfs.Items[rgdlfs.ItemIndex]+'['+msqHead.FieldByName('mbtypename').AsString+']'
   // else
    FieldByName('mb_desc').Value := edMatIoId.Text+'['+msqHead.FieldByName('mbtypename').AsString+']' ;

    Post;
    Append;
    FieldByName('parientid').Value := Trim(edMbNumber.Text);
    FieldByName('treeid').Value := Trim(edMbNumber.Text)+'1';
    FieldByName('mb_desc').Value := edStyleNo.Text+'['+Trim(edStyleDesc.Text)+']';
    Post;
  end;
  tvGroup.OnChange := tvGroupChange;

  ShowActiveProgress('保存成功！',100,IsShowProgress);
  IsShowProgress := False;
  plProgress.Visible := False;
  btnInsert1.tag:=0;
  btnEdit1.tag:=0;
  btnTransord.Tag:=0;
end;
