
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ПрибыльПоПроектам Расход
	Движения.ПрибыльПоПроектам.Записывать = Истина;
	Движение = Движения.ПрибыльПоПроектам.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период = Дата;
	Движение.Проект = Проект;
	Движение.СтатьяЗатрат = Справочники.СтатьиЗатрат.РабочееВремя;
	Движение.Сумма = СуммаДокумента;
	
	// регистр Начисления Приход
	Движения.Начисления.Записывать = Истина;
	СуммаНачислений = 0;
	Для Каждого СтрокаНачислений ИЗ ТабельРабочегоВремени Цикл 
		Если СтрокаНачислений.ВНачисление Тогда
			СуммаНачислений = СуммаНачислений + СтрокаНачислений.Сумма; 
		КонецЕсли;	
	КонецЦикла;
	Если СуммаНачислений > 0 И Согласовано Тогда
		Движение = Движения.Начисления.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Сотрудник = Сотрудник;
		Движение.Сумма = СуммаНачислений;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Проекты") Тогда
 	    ЗаполнениеДокументовСервер.ЗаполнитьОбъектПоПроекту(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	СуммаДокумента = ТабельРабочегоВремени.Итог("Сумма");
КонецПроцедуры
