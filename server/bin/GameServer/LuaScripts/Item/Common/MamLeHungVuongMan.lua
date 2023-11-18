-- Mỗi khi Script được thực thi, ID tương ứng sẽ được lưu trong hệ thống, tại bảng 'Scripts'
-- Dạng đối tượng là dạng Class, được khởi tạo mặc định bởi hệ thống, và sau đó được lưu tại bảng
-- Khi sử dụng dạng Class, cần phải kế thừa Class được hệ thống sinh ra, và dòng lệnh bên dưới để làm điều đó
-- ID Script được khai báo ở file ScriptIndex.xml, thay thế giá trị '200005' bên dưới thành ID tương ứng
local MamLeHungVuongMan = Scripts[200306]
--[[Mâm Lễ Mặn:
•	100 lần rương bí kíp 150 id 10468 x1
•	300 lần rương bí kíp 150 id 10468 x1
•	600 Thẻ đổi tên id 2167 x1
•	900 lần Ngựa Phiên Vũ id 8160 x1
•	1200 lần Rương trang bị kim quang id 11263 x1
•	1500 lần Rương trang bị kim quang id 11263 x2
•	2000 lần Rương chọn thú cưỡi x1
]]
local ToRecord = 15
local TotalRecord = 2001
local RecordKeyMamLe = 20032024;                                                                      --không được thay đổi Key mâm lễ Mặn
local ToRecord15 = { ItemToRecord = 186, NumberToRecord = 1, SeriesToRecord = -1, BinToRecord = 1, }  --Huyền tinh 4

local _receivingMilestone = {
    [100] = { Item = 10468, Number = 1, Series = -1, Bin = 1 },
    [300] = { Item = 10468, Number = 1, Series = -1, Bin = 1 },
    [600] = { Item = 2167, Number = 1, Series = -1, Bin = 1 },
    [900] = { Item = 8160, Number = 1, Series = -1, Bin = 1 },
    [1200] = { Item = 11263, Number = 1, Series = -1, Bin = 1 },
    [1500] = { Item = 11263, Number = 2, Series = -1, Bin = 1 },
    [2000] = { Item = 8874, Number = 1, Series = -1, Bin = 1 },
}
-- ****************************************************** --
--	Hàm này được gọi khi người chơi ấn sử dụng vật phẩm, kiểm tra điều kiện có được dùng hay không
--		scene: Scene - Bản đồ hiện tại
--		item: Item - Vật phẩm tương ứng
--		player: Player - NPC tương ứng
--	Return: True nếu thỏa mãn điều kiện có thể sử dụng, False nếu không thỏa mãn
-- ****************************************************** --
function MamLeHungVuongMan:OnPreCheckCondition(scene, item, player, otherParams)
    -- ************************** --
    --player:AddNotification("Enter -> MamLeHungVuongMan:OnPreCheckCondition")--
    -- ************************** --
    return true
    -- ************************** --
end

-- ****************************************************** --
--	Hàm này được gọi để thực thi Logic khi người sử dụng vật phẩm, sau khi đã thỏa mãn hàm kiểm tra điều kiện
--		scene: Scene - Bản đồ hiện tại
--		item: Item - Vật phẩm tương ứng
--		player: Player - NPC tương ứng
-- ****************************************************** --
function MamLeHungVuongMan:OnUse(scene, item, player, otherParams)
    local dialog = GUI.CreateItemDialog()
    local ItemID = item:GetItemID()
    local nLevel = item:GetItemLevel()
    -- if 1 < nLevel > 3 then
    -- player:AddNotification("Vật phẩm không hợp lệ!")
    -- return
    --  end
    -- Số lượng đã sử dụng
    local usedValue = Player.GetValueForeverRecore(player, RecordKeyMamLe)
    if usedValue == -1 then
        usedValue = 1
    end
    --  player:AddNotification(ItemID.."item:getId->"..item:GetID().."")
    local GetValueItemToRecord = ToRecord15
    if (usedValue >= TotalRecord) then
        player:AddNotification("Mâm lễ này đã bạn đã dùng quà nhiều,Không thể dùng thêm nữa")
        return
    end
    -- Tăng số lượt đã dùng
    -- Lưu lại số lượt đã dùng
    Player.SetValueOfForeverRecore(player, RecordKeyMamLe, usedValue + 1)

    --xóa rương trước khi mở rương và + mốc
   
    -- Thực hiện mở Random quà trong hộp
    if Player.OpenRandomBox(player, item:GetID()) == true then
        player:AddNotification("Sử dụng Mâm Lễ thành công")
    else
        player:AddNotification("Sử dụng Mâm Lễ không thành công")
    end
    Player.RemoveItem(player, item:GetID())
    --chia hết cho 15 thì cho no nhận mốc 1 lần
    if (usedValue % ToRecord == 0) then
        self:AddItem(player, GetValueItemToRecord.ItemToRecord, GetValueItemToRecord.NumberToRecord,
            GetValueItemToRecord.SeriesToRecord, GetValueItemToRecord.BinToRecord)
        player:AddNotification("Nhận vật phẩm theo mốc 15 lần <color=red>thành công</color>")
    end
    for key, value in pairs(_receivingMilestone) do
        if (usedValue == key) then
            self:AddItem(player, value.Item, value.Number, value.Series, value.Bin)
            player:AddNotification("Nhận vật phẩm theo mốc <color=red>thành công</color>")
        end
    end

    -- Thông báo
    player:AddNotification("Sử dụng thành công Số lượng đã mở " ..
        usedValue .. " " .. item:GetName() .. ".")
    -- ************************** --


    -- ************************** --
end

-- ****************************************************** --
--	Hàm này được gọi khi có sự kiện người chơi ấn vào một trong số các chức năng cung cấp bởi vật phẩm thông qua Item Dialog
--		scene: Scene - Bản đồ hiện tại
--		item: Item - Vật phẩm tương ứng
--		player: Player - NPC tương ứng
--		selectionID: number - ID chức năng
-- ****************************************************** --
function MamLeHungVuongMan:OnSelection(scene, item, player, selectionID, otherParams)

end

-- ****************************************************** --
--	Hàm này được gọi khi có sự kiện người chơi chọn một trong các vật phẩm, và ấn nút Xác nhận cung cấp bởi vật phẩm thông qua Item Dialog
--		scene: Scene - Bản đồ hiện tại
--		item: Item - Vật phẩm tương ứng
--		player: Player - NPC tương ứng
--		itemID: number - ID vật phẩm được chọn
-- ****************************************************** --
function MamLeHungVuongMan:OnItemSelected(scene, item, player, itemID)
    -- ************************** --

    -- ************************** --
end

function MamLeHungVuongMan:AddItem(player, Item, number, seri, Look)
    -- ************************** --
    if (Item == nil) then
        return
    end
    if (number == nil) then
        return
    end
    Player.AddItemLua(player, Item, number, seri, Look)
    -- ************************** --
end
