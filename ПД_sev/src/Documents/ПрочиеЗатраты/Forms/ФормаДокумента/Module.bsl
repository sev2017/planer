
&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	ТекСтрока.Сумма = ТекСтрока.Цена * ТекСтрока.Количество; 
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	ТекСтрока.Сумма = ТекСтрока.Цена * ТекСтрока.Количество; 
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	РаботаСФормамиКлиент.ОповеститьПослеЗаписиФормы("ЗаписьНаФорме", Объект.Ссылка, Новый Структура("Проект", Объект.Проект));
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не (ОбщегоНазначенияПовтИсп.ПроверитьДоступностьРоли("ПолныеПрава") 
		ИЛИ ОбщегоНазначенияПовтИсп.ПроверитьДоступностьРоли("РуководительПОдразделения")) Тогда		
		Элементы.Согласовано.Доступность = Ложь;	
	КонецЕсли;
КонецПроцедуры
