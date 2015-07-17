//
//  ContactService.swift
//  SeCall
//
//  Created by Bi Brain on 7/1/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import Foundation
public class ContactService{

    func addContact(contact:ContactEntity)-> Bool{
       return ModelUtility.AddContact(contact)
    }
    
    func deleteContact(index:Int){
        ModelUtility.DeleteContact(index)
    }
    
    func getContacts()->[ContactEntity]{
        return ModelUtility.GetContacts()
    }
    func checkExistContact(phone:String)->Bool{
        return ModelUtility.CheckExistContact(phone)
    }
    func deleteAllContact(){
        ModelUtility.DeleteAllContact()
    }
    func editContact(index:Int,newName:String,newPhone:String){
        ModelUtility.EditContact(index, newName: newName, newPhone: newPhone)
    }
}
