PUBLIC DEFINE m_stat STRING
--------------------------------------------------------------------------------
FUNCTION mkdb_progress(l_mess STRING)
  LET l_mess = CURRENT, ":", NVL(l_mess, "NULL!")
  LET m_stat = m_stat.append(l_mess || "\n")
  DISPLAY l_mess
  DISPLAY BY NAME m_stat
  CALL ui.Interface.refresh()
END FUNCTION