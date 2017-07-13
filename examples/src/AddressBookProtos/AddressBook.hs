{-# LANGUAGE BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module AddressBookProtos.AddressBook (AddressBook(..)) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified AddressBookProtos.Person as AddressBookProtos (Person)

data AddressBook = AddressBook{person :: !(P'.Seq AddressBookProtos.Person)}
                 deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

instance P'.Mergeable AddressBook where
  mergeAppend (AddressBook x'1) (AddressBook y'1) = AddressBook (P'.mergeAppend x'1 y'1)

instance P'.Default AddressBook where
  defaultValue = AddressBook P'.defaultValue

instance P'.Wire AddressBook where
  wireSize ft' self'@(AddressBook x'1)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeRep 1 11 x'1)
  wirePut ft' self'@(AddressBook x'1)
   = case ft' of
       10 -> put'Fields
       11 -> do
               P'.putSize (P'.wireSize 10 self')
               put'Fields
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = do
             P'.wirePutRep 10 11 x'1
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{person = P'.append (person old'Self) new'Field}) (P'.wireGet 11)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> AddressBook) AddressBook where
  getVal m' f' = f' m'

instance P'.GPB AddressBook

instance P'.ReflectDescriptor AddressBook where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [10])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".tutorial.AddressBook\", haskellPrefix = [], parentModule = [MName \"AddressBookProtos\"], baseName = MName \"AddressBook\"}, descFilePath = [\"AddressBookProtos\",\"AddressBook.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".tutorial.AddressBook.person\", haskellPrefix' = [], parentModule' = [MName \"AddressBookProtos\",MName \"AddressBook\"], baseName' = FName \"person\", baseNamePrefix' = \"\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".tutorial.Person\", haskellPrefix = [], parentModule = [MName \"AddressBookProtos\"], baseName = MName \"Person\"}), hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = False}"

instance P'.TextType AddressBook where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg AddressBook where
  textPut msg
   = do
       P'.tellT "person" (person msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'person]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'person
         = P'.try
            (do
               v <- P'.getT "person"
               Prelude'.return (\ o -> o{person = P'.append (person o) v}))